// Import the Mongoose Code model for database interaction
const Code = require("../../models/verificationCode");

// Crypto module for generating more secure numbers than Math.random can provide
const crypto = require("crypto");

// Nodemailer module for actual emailing
const nodemailer = require("nodemailer");

// Allow us to log mail events and failures
const fs = require("fs");
const logger = require("./logging").genericLogger;

// Mail transporter object
const transporter =
  process.env.DO_EMAIL == 1
    ? nodemailer.createTransport({
        host: process.env.MAIL_SERVER,
        port: process.env.MAIL_PORT,
        secure: false,
        auth: {
          user: process.env.MAIL_USERNAME,
          pass: process.env.MAIL_PASSWORD,
        },
      })
    : null;

// Configuration loaded from environment
const codeLength = process.env.CODE_LENGTH || 6;
const doEmail = process.env.DO_EMAIL || 0;

// Load the HTML file to use as a template for emails (if configured to do so)
const emailTemplate = process.env.EMAIL_TEMPLATE
  ? fs.readFileSync(process.env.EMAIL_TEMPLATE, "utf8")
  : "Hello ${name}, your code is ${verifCode}";

// Generate a verification code of N digits to be sent to a user
function generateVerificationCode(digits, name,id, purpose) {
  let generatedCode = crypto.randomInt(0, Math.pow(10, digits)).toString(10);

  // The int needs to be padded with leading zeros
  if (generatedCode.length != digits) {
    while (generatedCode.length != digits) {
      generatedCode = "0" + generatedCode;
    }
  }

  const code = new Code({
    code: generatedCode,
    user: id,
    purpose: purpose,
  });

  code.save().catch(function (err) {
    console.log(err);
  });

  console.log(`Code for ${name} is ${generatedCode} for ${purpose}`);

  return generatedCode;
}

// Send a verification email to the specified user
async function sendVerificationEmail(id, name, email) {
  const verifCode = generateVerificationCode(
    codeLength,
    name,
    id,
    "Email Verification"
  );
  var failFlag = false;

  // Do not email on development machines
  if (doEmail == 0) return true;

  await transporter.sendMail(
    {
      from: `"Recipe-Me" <no-reply@${process.env.MAIL_SERVER}>`,
      to: email,
      subject: "Email Verification Requested",
      text: `Hello ${name}, your verification code is ${verifCode}`,
      html: emailTemplate
        .replace("${name}", name)
        .replace("${verifCode}", verifCode),
    },
    function (err, info) {
      logger.info(info.envelope);

      if (err) failFlag = true;
    }
  );

  return !failFlag;
}

// Send a verification email to the specified user
async function sendForgotPasswordEmail(id, name, email) {
  const verifCode = generateVerificationCode(codeLength, name,id, "Forgot Password");
  var failFlag = false;

  // Do not email on development machines
  if (doEmail == 0) return true;

  await transporter.sendMail(
    {
      from: `"Recipe-Me" <no-reply@${process.env.MAIL_SERVER}>`,
      to: email,
      subject: "Forgot Password",
      text: `Hello ${name}, your code is ${verifCode}`,
      html: emailTemplate
        .replace("${name}", name)
        .replace("${verifCode}", verifCode),
    },
    function (err, info) {
      logger.info(info.envelope);

      if (err) failFlag = true;
    }
  );

  return !failFlag;
}

module.exports = {
  generateVerificationCode: generateVerificationCode,
  sendVerificationEmail: sendVerificationEmail,
  sendForgotPasswordEmail: sendForgotPasswordEmail,
};
