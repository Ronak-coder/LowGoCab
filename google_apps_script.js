// ═══════════════════════════════════════════════════════════════════════════
// LOWGO CAB — Universal Email Relay Script
// PASTE THIS INTO YOUR GOOGLE APPS SCRIPT EDITOR
//
// DEPLOY: Deploy → New Deployment → Web App
//         Execute as: Me | Who has access: Anyone
// ═══════════════════════════════════════════════════════════════════════════

function doPost(e) {
  return handleRequest(e);
}

function doGet(e) {
  // Health check — open URL in browser to verify it's live
  return ContentService
    .createTextOutput('✅ LowGo Cab Email Service is LIVE! Deployed by: ' + Session.getActiveUser().getEmail())
    .setMimeType(ContentService.MimeType.TEXT);
}

function handleRequest(e) {
  try {
    var data;

    // Parse body — supports both JSON and plain text
    if (e && e.postData && e.postData.contents) {
      try {
        data = JSON.parse(e.postData.contents);
      } catch (parseErr) {
        // If JSON parse fails, try URL-encoded params
        data = e.parameter;
      }
    } else if (e && e.parameter) {
      data = e.parameter;
    } else {
      throw new Error('No data received');
    }

    if (!data || !data.to || !data.subject) {
      throw new Error('Missing required fields: to=' + (data ? data.to : 'null') + ', subject=' + (data ? data.subject : 'null'));
    }

    // Send the email using GmailApp (works best with Workspace accounts)
    GmailApp.sendEmail(
      data.to,
      data.subject,
      'Please view this email in an HTML-compatible email client.',
      {
        htmlBody: data.body || '<p>' + data.subject + '</p>',
        replyTo: data.replyTo || '',
        name: 'LowGo Cab'
      }
    );

    console.log('Email sent to: ' + data.to + ' | Subject: ' + data.subject);

    return ContentService
      .createTextOutput(JSON.stringify({ status: 'ok', to: data.to }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    console.error('Error in handleRequest: ' + err.toString());
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'error', message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// ── Run this manually to test ─────────────────────────────────────────────
function testSendEmail() {
  var me = Session.getActiveUser().getEmail();
  GmailApp.sendEmail(me, 'LowGo Cab Test ✅', '', {
    htmlBody: '<h2 style="color:#EE0B5E;">LowGo Cab Email Service</h2><p>Working perfectly! Emails will now be sent to <b>pragyank@lowgocab.online</b> for every booking.</p>',
    name: 'LowGo Cab'
  });
  console.log('Test email sent to: ' + me);
}

// ── Simulate a full booking request ──────────────────────────────────────
function testDoPost() {
  var me = Session.getActiveUser().getEmail();
  var fakeEvent = {
    postData: {
      contents: JSON.stringify({
        to: 'pragyank@lowgocab.online',
        subject: '[LowGo Cab] 🚕 New Booking: Jaipur Sightseeing — Test User',
        body: '<h2>New Booking</h2><p>Name: Test User<br>Mobile: 9999999999<br>From: Jaipur<br>To: Delhi</p>',
        replyTo: me
      })
    }
  };
  var result = handleRequest(fakeEvent);
  console.log('Result: ' + result.getContent());
}
