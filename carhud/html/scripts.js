// $(document).ready(function () {
//   // Listen for NUI Events
//   window.addEventListener('message', function (event) {
//     var item = event.data;
//     // Trigger adding a new message to the log and create its display
//     if (item.action == 'circle') {
//       if (item.value31 == false) {
//         $(".full-screen").css("left", "7vh");
//       } else {
//         $(".full-screen").css("left", "0vh");
//       }
//     }
//     if (item.open === 2) {
//       // console.log(3)
//       // update(item.info);

//       if (item.direction) {
//         $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
//         return;
//       }

//       $("#cambardak2").css("bottom", "6vh");

//       if (item.atl === false) {
//         $(".alt").css("display", "none");
//         $(".alttext").css("display", "none");
//       }
//       else {
//         $(".alt").css("display", "block");
//         $(".alttext").css("display", "block");
//         $(".alt").empty();
//         $(".alt").append(item.atl);
//       }

//       $(".vehicle").removeClass("hide");
//       $(".wrap").removeClass("lower");
//       $(".time").removeClass("timelower");

//       $(".fuelamount").empty();
//       $(".fuelamount").append(item.fuel);
//       setProgressFuel(item.fuel, '.progress-fuel');

//       $(".speedamount").empty();
//       $(".speedamount").append(item.mph);
//       setProgressSpeed(item.mph, '.progress-speed');

//       $(".street-txt").empty();
//       $(".street-txt").append(item.street);

//       $(".time").empty();
//       $(".time").append(item.time);


//       if (item.belt == true || item.harnessDur > 0) {
//         $(".belt").fadeOut(1000);
//       } else {
//         $(".belt").fadeIn(1000);
//       }

//       if (item.engine === true) {
//         $(".ENGINE").fadeIn(1000);
//       } else {
//         $(".ENGINE").fadeOut(1000);
//       }

//       if (item.GasTank === true) {
//         $(".FUEL").fadeIn(1000);
//       } else {
//         $(".FUEL").fadeOut(1000);
//       }

//       $(".harness").empty();
//       if (item.harnessDur > 0) {
//         if (item.harness === true) {
//           let colorOn = (item.colorblind) ? 'blue' : 'green';
//           $(".harness").append(`<div class='${colorOn}'> HARNESS </div>`);
//         } else {
//           let colorOff = (item.colorblind) ? 'yellow' : 'red';
//           $(".harness").append(`<div class='${colorOff}'> HARNESS </div>`);
//         }
//       }

//       $(".nos").empty();
//       if (item.nos > 0) {
//         if (item.nosEnabled === false) {
//           let colorOn = (item.colorblind) ? 'blue' : 'green';
//           $(".nos").append(`<div class='${colorOn}'> ${item.nos} </div>`);
//         } else {
//           let colorOff = (item.colorblind) ? 'yellow' : 'yellow';
//           $(".nos").append(`<div class='${colorOff}'> ${item.nos} </div>`);
//         }
//       }
//     }

//     if (item.open === 4) {
//       $(".vehicle").addClass("hide");
//       $(".wrap").addClass("lower");
//       $(".time").addClass("timelower");
//       $(".fuelamount").empty();
//       $(".speedamount").empty();
//       $(".street-txt").empty();

//       $(".time").empty();
//       $(".time").append(item.time);
//       $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
//     }

//     if (item.open === 3) {
//       $(".full-screen").fadeOut(100);
//     }

//     if (item.open === 5) {
//       $(".street").fadeOut(100);
//       $(".full-screen").css("bottom", "3%");
//     }

//     if (item.open === 6) {
//       $(".street").fadeIn(100);
//       $(".full-screen").css("bottom", "10%");
//       $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
//       return
//     }

//     if (item.open === 7) {
//       $("#cambardak2").css("bottom", "6vh");
//       $("#cambardak").fadeIn(100);
//       $("#cambardak").empty();
//       $("#cambardak").append(item.area);
//       $("#cambardak2").css("margin-top", "1.55vh");
//     }

//     if (item.open === 8) {
//       $("#cambardak2").fadeIn(100);
//       $("#cambardak2").empty();
//       $("#cambardak2").append(item.street);
//       //$("#cambardak2").css("margin-top", "5vh");
//     }

//     if (item.open === 9) {
//       $("#cambardak2").css("margin-top", "4.7vh");
//       //console.log("evet");
//       $("#cambardak").fadeOut(100);


//     }

//     if (item.open === 10) {
//       $("#cambardak2").fadeOut(100);
//     }


//     if (item.open === 1) {
//       //console.log(1)
      
//       $(".full-screen").fadeIn(100);
//     }
//   });
// });

window.addEventListener('message', function(event){
  data = event.data;
  if (data.action == "update") {
    $("#main-app-container").css("display", "block")

    setProgressSpeed(data.speed * 2, '#hizbar');
    setProgressFuel(data.fuel, '#benzin');

    $("#speedhiz").empty();
    $("#speedhiz").append(data.speed);

    if (data.seatbelt) {
      $("#kemer").fadeOut(500)
    } else {
      $("#kemer").fadeIn(500)
    }

    if (data.engine) {
      $("#motordurum").fadeIn(500)
    } else {
      $("#motordurum").fadeOut(500)
    }

    if (data.atl) {
      $("#yukseklikbar").fadeIn(500)
      setProgressAlt(data.atl, '#yukseklikzibab');

      $("#yukseklik").empty();
      $("#yukseklik").append(data.atl);
    } else {
      $("#yukseklikbar").fadeOut(500)
    }
  }

  if (data.action == "close") {
    $("#main-app-container").css("display", "none")
  }

  if (data.action == "ovalmap") {
    if (data.mod == "default") {
      $(".jss113").css("left", "calc(16.375vw)")
    } else {
      $(".jss113").css("left", "calc(14.375vw)")
    }
  }
});


function setProgressSpeed(value, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value * 100 / 220;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100) / 230 * circumference;
  circle.style.strokeDashoffset = -offset;

  var predkosc = Math.floor(value * 1.8)
  if (predkosc == 81 || predkosc == 131) {
    predkosc = predkosc - 1
  }

  html.text(predkosc);
}

function setProgressAlt(value, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value * 100 / 220;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100) / 230 * circumference;
  circle.style.strokeDashoffset = -offset;

  if (offset > 290) {
    circle.style.strokeDashoffset = 55;
  } else if (offset < 290) {
    circle.style.strokeDashoffset = -offset;
  }
}

function setProgressFuel(percent, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}

function mat(x){
  var deger = x;

  var partialValue = 56;

  var yuzde = 100/deger;

  var mat = partialValue/yuzde;

  var lastVal = partialValue - mat;
  return lastVal
}