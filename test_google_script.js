// -----------------------------------------------------------------------
// PASTE THIS INTO YOUR GOOGLE APPS SCRIPT EDITOR TO TEST MANUALLY
// -----------------------------------------------------------------------

// 1. Select 'testSendEmail' from the dropdown menu up top.
// 2. Click 'Run'.
// 3. If it asks for permissions, click 'Review Permissions' -> Choose Account -> Allow.
// 4. Check your inbox!

function testSendEmail() {
  const myEmail = Session.getActiveUser().getEmail();
  
  console.log("Attempting to send email to:", myEmail);
  
  MailApp.sendEmail({
    to: myEmail,
    subject: "Test Email from LowGo Script",
    htmlBody: "<h1>Success!</h1><p>Your Google Apps Script is working correctly.</p>"
  });
  
  console.log("Email sent! Check your inbox.");
}

// DO NOT RUN doPost MANUALLY - IT WILL FAIL WITH "postData undefined"
function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);
    
    // Admin Notification
    MailApp.sendEmail({
      to: data.to,
      subject: data.subject,
      htmlBody: data.body,
      replyTo: data.replyTo || ''
    });
    
    // Customer Confirmation
    if (data.customerEmail) {
      MailApp.sendEmail({
        to: data.customerEmail,
        subject: data.customerSubject,
        htmlBody: data.customerBody,
        replyTo: data.to
      });
    }
    
    return ContentService.createTextOutput(JSON.stringify({status: 'ok'})).setMimeType(ContentService.MimeType.JSON);
  } catch(err) {
    return ContentService.createTextOutput(JSON.stringify({status: 'error', message: err.toString()})).setMimeType(ContentService.MimeType.JSON);
  }
}
