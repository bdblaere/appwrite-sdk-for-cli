const Client = require("./client");
const { globalConfig, localConfig } = require("./config");

const sdkForConsole = async (requiresAuth = true) => {
  let client = new Client();
  let endpoint = globalConfig.getEndpoint();
  let cookie = globalConfig.getCookie()
  let selfSigned = globalConfig.getSelfSigned()

  if (requiresAuth && cookie === "") {
    throw new Error("Session not found. Please run `appwrite login` to create a session");
  }

  client
    .setEndpoint(endpoint)
    .setCookie(cookie)
    .setProject("console")
    .setSelfSigned(selfSigned)
    .setLocale("en-US");

  return client;
};

const sdkForProject = async () => {
  let client = new Client();
  let endpoint = localConfig.getEndpoint() || globalConfig.getEndpoint();
  let project = localConfig.getProject().projectId ? localConfig.getProject().projectId : globalConfig.getProject();
  let key = globalConfig.getKey();
  let cookie = globalConfig.getCookie()
  let selfSigned = globalConfig.getSelfSigned()

  if (!project) {
    throw new Error("Project is not set. Please run `appwrite init project` to initialize the current directory with an Appwrite project.");
  }

  client
    .setEndpoint(endpoint)
    .setProject(project)
    .setSelfSigned(selfSigned)
    .setLocale("en-US");

  if (cookie) {
    return client
      .setCookie(cookie)
      .setMode("admin");
  }

  if (key) {
    return client
      .setKey(key)
      .setMode("default");
  }

  throw new Error("Session not found. Please run `appwrite login` to create a session.");
};

module.exports = {
  sdkForConsole,
  sdkForProject,
};
