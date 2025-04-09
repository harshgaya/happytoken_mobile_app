const { initializeApp } = require('firebase-admin/app');
const axios = require('axios');
const { logger } = require('firebase-functions');
const {
  onNewFatalIssuePublished,
  onNewNonfatalIssuePublished,
} = require('firebase-functions/v2/alerts/crashlytics');

initializeApp();

const webhookUrl = 'https://happytokenapi.softplix.com/api/admin/error-webhook';

// 🔄 Reusable handler
async function handleCrashlyticsIssue(event, type) {
  const appId = event.appId;
  const { id, title, subtitle, appVersion } = event.data.payload.issue;

  const message = {
    type: type, // 'fatal' or 'nonfatal'
    appId: appId,
    issueId: id,
    title: title,
    subtitle: subtitle,
    appVersion: appVersion,
  };

  try {
    const response = await axios.post(webhookUrl, message);

    if (response.status === 200) {
      logger.info(`✅ Sent ${type} crash alert for ${id} to webhook`);
    } else {
      logger.error(`❌ Webhook responded with status ${response.status}`);
    }
  } catch (error) {
    logger.error('❌ Failed to send webhook:', error.message);
  }
}

// 🧨 Fatal crash trigger
exports.onNewFatalCrashIssue = onNewFatalIssuePublished(async (event) => {
  await handleCrashlyticsIssue(event, 'fatal');
});

// 🚫 Non-fatal crash trigger
exports.onNewNonfatalCrashIssue = onNewNonfatalIssuePublished(async (event) => {
  await handleCrashlyticsIssue(event, 'nonfatal');
});
