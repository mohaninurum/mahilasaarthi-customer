import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_routes.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/requests/auth.request.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/widgets/bottomsheets/account_verification_entry.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterViewModel extends MyBaseViewModel {
  //
  AuthRequest _authRequest = AuthRequest();
  // FirebaseAuth auth = FirebaseAuth.instance;
  //the textediting controllers
  TextEditingController nameTEC =
      new TextEditingController(text: !kReleaseMode ? "John Doe" : "");
  TextEditingController emailTEC =
      new TextEditingController(text: !kReleaseMode ? "john@mail.com" : "");
  TextEditingController phoneTEC =
      new TextEditingController(text: !kReleaseMode ? "557484181" : "");
  TextEditingController passwordTEC =
      new TextEditingController(text: !kReleaseMode ? "password" : "");
  TextEditingController referralCodeTEC = new TextEditingController();
  Country? selectedCountry;
  String? accountPhoneNumber;
  bool agreed = false;
  bool aadhaarConsent = false;
  bool otpLogin = AppStrings.enableOTPLogin;

  String? aadhaarRefId;
  String? aadhaarNumber;
  Map<String, dynamic>? aadhaarDetails;
  File? selfieImage;

  RegisterViewModel(BuildContext context) {
    this.viewContext = context;
    this.selectedCountry = Country.parse("us");
  }

  void initialise() async {
    try {
      String countryCode = await Utils.getCurrentCountryCode();
      this.selectedCountry = Country.parse(countryCode);
    } catch (error) {
      this.selectedCountry = Country.parse("us");
    }
  }

  //
  showCountryDialPicker() {
    showCountryPicker(
      context: viewContext,
      showPhoneCode: true,
      onSelect: countryCodeSelected,
    );
  }

  countryCodeSelected(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  void processRegister() async {
    //
    accountPhoneNumber = "+${selectedCountry?.phoneCode}${phoneTEC.text}";
    //
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      if (!agreed) {
        viewContext.showToast(
          msg: "Please agree to the Terms & Conditions".tr(),
          bgColor: Colors.red,
        );
        return;
      }
      if (!aadhaarConsent) {
        viewContext.showToast(
          msg: "Please provide your consent for Aadhaar verification".tr(),
          bgColor: Colors.red,
        );
        return;
      }
      //
      if (AppStrings.isFirebaseOtp) {
        processFirebaseOTPVerification();
      } else if (AppStrings.isCustomOtp) {
        processCustomOTPVerification();
      } else {
        startAadhaarVerification();
      }
    }
  }

  //PROCESSING VERIFICATION
  processFirebaseOTPVerification() async {
    setBusy(true);
    //firebase authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: accountPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // firebaseVerificationId = credential.verificationId;
        // verifyFirebaseOTP(credential.smsCode);
        startAadhaarVerification();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          viewContext.showToast(
              msg: "Invalid Phone Number".tr(), bgColor: Colors.red);
        } else {
          viewContext.showToast(
              msg: e.message ?? "Failed".tr(), bgColor: Colors.red);
        }
        //
        setBusy(false);
      },
      codeSent: (String verificationId, int? resendToken) async {
        firebaseVerificationId = verificationId;
        showVerificationEntry();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout called");
      },
    );
  }

  processCustomOTPVerification() async {
    setBusy(true);
    try {
      final response = await _authRequest.sendOTP(accountPhoneNumber!);
      setBusy(false);
      showVerificationEntry(response.body?['otp_code']?.toString());
    } catch (error) {
      setBusy(false);
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
  }

  //
  void showVerificationEntry([String? otpCode]) async {
    //
    setBusy(false);
    //
    await viewContext.push(
      (context) => AccountVerificationEntry(
        vm: this,
        phone: accountPhoneNumber!,
        otpCode: otpCode,
        onSubmit: (smsCode) {
          //
          if (AppStrings.isFirebaseOtp) {
            verifyFirebaseOTP(smsCode);
          } else if (AppStrings.isCustomOtp) {
            verifyCustomOTP(smsCode);
          }

          viewContext.pop();
        },
        onResendCode: AppStrings.isCustomOtp
            ? () async {
                try {
                  final response = await _authRequest.sendOTP(
                    accountPhoneNumber!,
                  );
                  toastSuccessful("${response.message}");
                } catch (error) {
                  viewContext.showToast(msg: "$error", bgColor: Colors.red);
                }
              }
            : () {},
      ),
    );
  }

  //
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(firebaseVerificationId, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      await startAadhaarVerification();
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  void verifyCustomOTP(String smsCode) async {
    //
    setBusyForObject(firebaseVerificationId, true);
    // Sign the user in (or link) with the credential
    try {
      await _authRequest.verifyOTP(accountPhoneNumber!, smsCode);
      await startAadhaarVerification();
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  // --- AADHAAR & FACE VERIFICATION FLOW ---
  Future<void> startAadhaarVerification() async {
    setBusy(false);
    TextEditingController aadhaarTEC = TextEditingController();
    showDialog(
      context: viewContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Aadhaar Verification".tr()),
          content: TextField(
            controller: aadhaarTEC,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              hintText: "Enter 12-digit Aadhaar Number".tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () {
                if (aadhaarTEC.text.length == 12) {
                  Navigator.pop(context);
                  submitAadhaarNumber(aadhaarTEC.text);
                } else {
                  toastError("Enter valid 12 digit Aadhaar".tr());
                }
              },
              child: Text("Generate OTP".tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitAadhaarNumber(String aadhaar) async {
    setBusy(true);
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.loading,
        text: "Generating OTP...".tr(),
        barrierDismissible: false);
    try {
      final response = await _authRequest.generateAadhaarOtp(aadhaar);
      Navigator.pop(viewContext);
      if (response.allGood || response.body['status'] == 'SUCCESS') {
        aadhaarNumber = aadhaar;
        aadhaarRefId = response.body['ref_id'];
        setBusy(false);
        String? otpCode = response.body['otp']?.toString() ?? response.body['otp_code']?.toString();
        if (otpCode != null && otpCode.length == 6) {
          submitAadhaarOtp(otpCode);
        } else {
          showAadhaarOtpEntry(otpCode);
        }
      } else {
        toastError(response.body['message'] ?? "Aadhaar API Error");
        setBusy(false);
      }
    } catch (e) {
      Navigator.pop(viewContext);
      toastError(e.toString());
      setBusy(false);
    }
  }

  void showAadhaarOtpEntry([String? otpCode]) {
    TextEditingController otpTEC = TextEditingController(text: otpCode);
    showDialog(
      context: viewContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Aadhaar OTP".tr()),
          content: TextField(
            controller: otpTEC,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: "Enter 6-digit Aadhaar OTP".tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () {
                if (otpTEC.text.length == 6) {
                  Navigator.pop(context);
                  submitAadhaarOtp(otpTEC.text);
                } else {
                  toastError("Enter valid OTP".tr());
                }
              },
              child: Text("Verify OTP".tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitAadhaarOtp(String otp) async {
    if (aadhaarRefId == null) return;
    setBusy(true);
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.loading,
        text: "Verifying OTP...".tr(),
        barrierDismissible: false);
    try {
      final response = await _authRequest.verifyAadhaarOtp(aadhaarRefId!, otp);
      Navigator.pop(viewContext);
      if (response.allGood ||
          response.body['status'] == 'SUCCESS' ||
          response.body['status'] == 'VALID') {
        aadhaarDetails = response.body;

        // Check gender
        String? gender;
        if (response.body != null) {
          gender = response.body['gender']?.toString().toUpperCase();
        }

        //  Only female check
        if (gender == 'M' || gender == 'MALE') {
          setBusy(false);
          showDialog(
            context: viewContext,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Registration Failed".tr()),
                content:
                    Text("Only females can register on Mahila Saarthi.".tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK".tr()),
                  ),
                ],
              );
            },
          );
          return;
        }

        toastSuccessful("Aadhaar Verified Successfully!".tr());
        setBusy(false);
        // Step 3: Face Liveness
        startFaceLivenessCheck();
      } else {
        toastError(response.body['message'] ?? "Invalid Aadhaar OTP");
        setBusy(false);
      }
    } catch (e) {
      Navigator.pop(viewContext);
      toastError(e.toString());
      setBusy(false);
    }
  }

  Future<void> startFaceLivenessCheck() async {
    setBusy(false);
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );

    if (image == null) {
      toastError(
          "Camera closed. Live Selfie is required for verification!".tr());
      return;
    }

    selfieImage = File(image.path);
    setBusy(true);
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.loading,
        text: "Verifying Face...".tr(),
        barrierDismissible: false);
    try {
      final response = await _authRequest.verifyFaceLiveness(selfieImage!);
      Navigator.pop(viewContext);
      if (response.allGood || response.body['status'] == 'SUCCESS') {
        if (response.body['liveness'] == true) {
          toastSuccessful("Face Verified! Live person detected.".tr());
          await finishAccountRegistration();
        } else {
          toastError("Face Liveness Failed. Please take a clear selfie.".tr());
          setBusy(false);
        }
      } else {
        toastError(response.body['message'] ?? "Face Verification Error");
        setBusy(false);
      }
    } catch (e) {
      Navigator.pop(viewContext);
      toastError(e.toString());
      setBusy(false);
    }
  }

  Future<void> finishAccountRegistration() async {
    setBusy(true);

    final String finalPhone = accountPhoneNumber ?? "+${selectedCountry?.phoneCode ?? '91'}${phoneTEC.text}";
    final String finalCountryCode = selectedCountry?.countryCode ?? "IN";

    final apiResponse = await _authRequest.registerRequest(
      name: nameTEC.text,
      email: emailTEC.text,
      phone: finalPhone,
      countryCode: finalCountryCode,
      password: passwordTEC.text,
      code: referralCodeTEC.text,
      aadhaarNumber: aadhaarNumber,
      aadhaarVerified: aadhaarDetails != null ? 1 : null,
      aadhaarName: aadhaarDetails != null
          ? (aadhaarDetails!['name'] ?? aadhaarDetails!['full_name'])
          : null,
      aadhaarGender: aadhaarDetails != null ? aadhaarDetails!['gender'] : null,
      aadhaarDob: aadhaarDetails != null ? aadhaarDetails!['dob'] : null,
    );

    setBusy(false);

    try {
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Registration Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"], reload: false);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        Navigator.of(viewContext).pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: error is Map ? "${error['message'] ?? error}" : "$error",
      );
    }
  }

  void openLogin() async {
    viewContext.pop();
  }

  verifyRegistrationOTP(String text) {}
}
