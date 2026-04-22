function updateStuffs(data) {

  document.getElementById("repPourcentage").style.width = data.rep + '%';
  document.getElementById("tasksList").innerHTML = '';

  var contents = "";

  //let tier = data.rep;
  let tier = data.rep;
  let btnN = 1;
  data.contracts.forEach((contract) => {
    if (tier >= contract.requiredRep) {
      contents += `<div class="item"><div class="_top_bar_1mr7c_8"><span>Tier ${contract.tier}</span><h1>${contract.veh}</h1></div><div class="thumb">`;

      if (contract.type == "Bank Delivery") {
        contents += `<img src="assets/sh.png">`;
      } else {
        contents += `<img src="assets/ssh.png">`;
      }

      contents += `</div><div class="infolist"><div class="info_item"><div class="lbl"><img class="ico" src="assets/type-icon-f8d69335.svg" alt=""><h1>Type</h1></div><span>${contract.type}</span></div></div><div class="infolist"><div class="info_item"><div class="lbl"><img class="ico" src="assets/bags-icon-c4f324c6.svg" alt=""><h1>Bags</h1></div><span>${contract.bags}</span></div></div><div class="infolist"><div class="info_item"><div class="lbl"><img class="ico" src="assets/payout-icon-6a4d3f59.svg" alt=""><h1>Payout</h1></div><span>$${contract.payout}</span> </div></div><button class="btn" id="btnNum${btnN}">Start Contract</button></div>`;

    }
    btnN += 1;
  });
  document.getElementById("tasksList").innerHTML = contents;
  
  btnN = 1;
  data.contracts.forEach((contract) => {
    if (tier >= contract.requiredRep) {
        var button = document.getElementById(`btnNum${btnN}`);

        button.onclick = (function (cp) {
          return function () {
            $.post(
              `https://${GetParentResourceName()}/exter-gruppe6job:StartShit`,
              JSON.stringify({
                index: cp.index,
              })
            );
  
            var body = $("body");
            body.fadeOut(700, function () {
              $.post(
                `https://${GetParentResourceName()}/exter-gruppe6job:hideMenu`
              );
            });
          };
        })(contract);

      
    }
    btnN += 1;
  });



  /* var button = document.getElementById(`btnNum${btnN}`);

      button.onclick = (function (cp) {
        return function () {
          $.post(
            `https://${GetParentResourceName()}/exter-gruppe6job:StartShit`,
            JSON.stringify({
              type: cp.type,
              payout: cp.payout,
              bags: cp.bags,
              vehicle: cp.veh,
            })
          );

          var body = $("body");
          body.fadeOut(700, function () {
            $.post(
              `https://${GetParentResourceName()}/exter-gruppe6job:hideMenu`
            );
          });
        };
      })(contract); */


}

window.addEventListener("message", function (event) {
  if (event.data.type === "open") {
    updateStuffs(event.data);

    document.body.style.display = "";
    document.getElementById("bD").style.display = "flex";
    document.getElementById("main").style.display = "flex";

    const buttons = document.querySelectorAll("._btn_vcubc_38");
    buttons.forEach((button) => {
      button.addEventListener("click", (event) => {
        var body = $("body");
        body.fadeOut(700, function () {
          $.post(
            `https://${GetParentResourceName()}/exter-gruppe6job:hideMenu`
          );
          document.getElementById("tasksList").innerHTML = "";
        });
      });
    });

  } else if (event.data.type === "hide") {
    document.getElementById("bD").style.display = "none";
    document.getElementById("main").style.display = "none";
    document.body.style.display = "none";

    document.getElementById("tasksList").innerHTML = "";
  }
});

document.addEventListener("keydown", function (event) {
  var keyPressed = event.key;
  switch (keyPressed) {
    case "Escape":
      var body = $("body");
      body.fadeOut(700, function () {
        /* var popupreverse = new Audio('popupreverse.mp3');
				popupreverse.volume = 0.4;
				popupreverse.play(); */
        $.post(`https://${GetParentResourceName()}/exter-gruppe6job:hideMenu`);
        document.getElementById("tasksList").innerHTML = "";
      });
      break;
  }
});
