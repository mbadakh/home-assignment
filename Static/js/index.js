document.querySelector("#vault-btn").addEventListener("click", () => {
  let secret = getSecret();
  document.getElementById("secret").innerHTML = secret;
});

function getSecret() {
  //send to backend and await response
  return "hi";
}
