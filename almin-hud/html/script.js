var health, armor, hunger, thirst, oxy, dogalgaz, nitro, db, wind, ping, ampul, dollar, yuzme, gym, harness, cruise, gpu, nos
var candegeri, zırhdegeri, yemekdegeri, sudegeri
var health2, armor2, hunger2, thirst2, oxy2, stress2
var time
var street = true
var compass = true
var yamert = false 

/* let data1 = {
    "healthInput": "false",
    "armorInput": "false",
    "hungerInput": "false",
    "thirstInput": "false"
}


NOT FOR NOW

let data2 = {
    "healthInput": "false",
    "armorInput": "false",
    "hungerInput": "false",
    "thirstInput": "false"
} */

window.addEventListener('message', function(event){
    data = event.data;
    if (data.action == "open") {
        $(".menu").fadeIn(500);
    }

    if (data.action == "squremap") {
        if (data.value == true) {
            $("#hudfull").css("left", "1vh");
        } else {
            $("#hudfull").css("left", "0vh");
        }
    }

    if (data.action == "voice") {
        voicemod = data.voice;
        talking = data.talking;
        radio = data.radio;

        if (voicemod == "3") {
            $("#voice").attr('stroke-dashoffset', 0);
        } else if (voicemod == "2") {
            $("#voice").attr('stroke-dashoffset', 41);
        } else if (voicemod == "1") {
            $("#voice").attr('stroke-dashoffset', 85);
        }

        // if (radio) {
        //     // console.log("sa")
        //     $("voiceicon").attr("class", "fab fa-teamspeak")
        // } else {
        //     // console.log("as")
        //     // $("voiceicon").attr("class", "fa fa-microphone")
        // }
        
        if (talking == true) {
            if (radio == true) {
                $("#voice").attr("stroke", "red");
                $("#voicebar").attr("stroke", "red");
            } else {
                $("#voice").attr("stroke", "yellow");
                $("#voicebar").attr("stroke", "yellow");
            }
        } else if (talking == false) {
            $("#voice").attr("stroke", "white");
            $("#voicebar").attr("stroke", "white");
        }
    }


    if (data.action == "carhud") {
        if (data.show == true) {
            $(".street").fadeIn(100);
            if (data.bar5 == true) {
                $(".mapborder").fadeIn();
            } else if (data.bar5 == false) {
                $(".mapborder").fadeOut();
            }

            if (street == false) {
                $("#cambardak").css("display", "none");
                $("#cambardak2").css("display", "none");
            } else if (street == true) {

                $("#cambardak").css("display", "block");
                $("#cambardak2").css("display", "block");

                $("#cambardak").empty();
                $("#cambardak").append(data.area);
    
                $("#cambardak2").empty();
                $("#cambardak2").append(data.street);
            }

            if (compass == false) {
                $(".direction").css("display", "none");
                $("#alahyoknk").css("display", "none");
            } else if (compass == true) {
                $(".direction").css("display", "block");
                $("#alahyoknk").css("display", "block");
                $(".direction").find(".image").attr('style', 'transform: translate3d(' + data.direction + 'px, 0px, 0px)');
            }

            if (data.mil == 0) {
                $("#cambardak3").css("display", "none");
            } else if (data.mil > 0) {
                $("#cambardak3").css("display", "block");
                $("#cambardak3").empty();
                let waypointactive = data.mil.toString()
                $("#cambardak3").append(waypointactive.slice(0,4)  + "mi");
            }

            if (time == false) {
                $("#cambardak4").css("display", "none");
            } else if (time == true) {
                $("#cambardak4").css("display", "block");
                $("#cambardak4").empty();
                $("#cambardak4").append(data.time);
            }

        } else if (data.show == false) {
            $(".street").fadeOut(100);
            $(".mapborder").fadeOut();
        }
    }

    if (data.action == "show") {
        if (data.show == false) {
            $("#hudfull").fadeOut(500);
        } else if (data.show == true) {
            $("#hudfull").fadeIn(1500);
            $("#healthfull").fadeIn(1500, function() { $("#healthfull").css("display", "flex"); });
            $("#armorfull").fadeIn(1500, function() { $("#armorfull").css("display", "flex"); });
            $("#hungerfull").fadeIn(1500, function() { $("#hungerfull").css("display", "flex"); });
            $("#thirstfull").fadeIn(1500, function() { $("#thirstfull").css("display", "flex"); });
            $("#oxyfull").fadeIn(1500, function() { $("#oxyfull").css("display", "flex"); });
            $("#dogalgazfull").fadeIn(1500, function() { $("#dogalgazfull").css("display", "flex"); });
            $("#stressfull").fadeIn(1500, function() { $("#stressfull").css("display", "flex"); });
            $("#dbfull").fadeIn(1500, function() { $("#dbfull").css("display", "flex"); });
            $("#windfull").fadeIn(1500, function() { $("#windfull").css("display", "flex"); });
            $("#pingfull").fadeIn(1500, function() { $("#pingfull").css("display", "flex"); });
            $("#ampulfull").fadeIn(1500, function() { $("#ampulfull").css("display", "flex"); });
            $("#dollarfull").fadeIn(1500, function() { $("#dollarfull").css("display", "flex"); });
            $("#yuzmefull").fadeIn(1500, function() { $("#yuzmefull").css("display", "flex"); });
            $("#gymfull").fadeIn(1500, function() { $("#gymfull").css("display", "flex"); });
            $("#harnessfull").fadeIn(1500, function() { $("#harnessfull").css("display", "flex"); });
            $("#cruisefull").fadeIn(1500, function() { $("#cruisefull").css("display", "flex"); });
            $("#nukefull").fadeIn(1500, function() { $("#nukefull").css("display", "flex"); });
            $("#gpsfull").fadeIn(1500, function() { $("#gpsfull").css("display", "flex"); });
            $("#gpufull").fadeIn(1500, function() { $("#gpsfull").css("display", "flex"); });
            $("#nosfull").fadeIn(1500, function() { $("#nosfull").css("display", "flex"); });
        }
    }

    if (data.action == "update") {
        var yazilancan = $("#healthValue").val();
        candegeri = yazilancan;
        var yazilanzırh = $("#armorValue").val();
        zırhdegeri = yazilanzırh;
        var yazilanyemek = $("#hungerValue").val();
        yemekdegeri = yazilanyemek;
        var yazilansu = $("#thirstValue").val();
        sudegeri = yazilansu;

        health = data.health
        armor = data.armor
        hunger = data.hunger
        thirst = data.thirst
        oxy = data.oxy
        stress = data.stress

        if (health2 == true) {
            $("#healthfull").fadeOut(500, function() { $("#healthfull").css("display", "none"); });
        } else {
            if (health) {
                if(data.health <= candegeri){ $("#healthfull").fadeIn(500, function() { $("#healthfull").css("display", "flex"); });}
                if(data.health > candegeri){ $("#healthfull").fadeOut(500, function() { $("#healthfull").css("display", "none"); }); }
                setBarValue(health, "#health")
            } else if (health == false) {
                $("#healthfull").fadeOut(500, function() { $("#healthfull").css("display", "none"); });
            }
        }

        if (armor2 == true) {
            $("#armorfull").fadeOut(500, function() { $("#armorfull").css("display", "none"); });
        } else {
            if (armor >= 0) {
                if(armor <= zırhdegeri) { $("#armorfull").fadeIn(500, function() { $("#armorfull").css("display", "flex"); });}
                if(armor > zırhdegeri) { $("#armorfull").fadeOut(500, function() { $("#armorfull").css("display", "none"); }); }
                setBarValue(armor, "#armor")
            } else if (armor == false) {
                $("#armorfull").fadeOut(500, function() { $("#armorfull").css("display", "none"); });
            }
        }

        if (hunger2 == true) {
            $("#hungerfull").fadeOut(500, function() { $("#hungerfull").css("display", "none"); });
        } else {
            if (hunger) {
                if(data.hunger < yemekdegeri){ $("#hungerfull").fadeIn(500, function() { $("#hungerfull").css("display", "flex"); });}
                if(data.hunger > yemekdegeri){ $("#hungerfull").fadeOut(500, function() { $("#hungerfull").css("display", "none"); }); }
                setBarValue(hunger, "#hunger")
            } else if (hunger == false) {
                $("#hungerfull").fadeOut(500, function() { $("#hungerfull").css("display", "none"); });
            }
        }

        if (thirst2 == true) {
            $("#thirstfull").fadeOut(500, function() { $("#thirstfull").css("display", "none"); });
        } else {
            if (thirst) {
                if(data.thirst < sudegeri){ $("#thirstfull").fadeIn(500, function() { $("#thirstfull").css("display", "flex"); });}
                if(data.thirst > sudegeri){ $("#thirstfull").fadeOut(500, function() { $("#thirstfull").css("display", "none"); }); }
                setBarValue(thirst, "#thirst")
            } else if (thirst == false) {
                $("#thirstfull").fadeOut(500, function() { $("#thirstfull").css("display", "none"); });
            }
        }

        if (oxy2 == true) {
            $("#oxyfull").fadeOut(500, function() { $("#oxyfull").css("display", "none"); });
        } else {
            if (oxy) {
                setBarValue(oxy, "#oxy")
                $("#oxyfull").fadeIn(500, function() { $("#oxyfull").css("display", "flex"); });
            } else if (data.oxy == false) {
                $("#oxyfull").fadeOut(500, function() { $("#oxyfull").css("display", "none"); });
            }
        }

        if (stress2 == true) {
            $("#stressfull").fadeOut(500, function() { $("#stressfull").css("display", "none"); });
        } else {
            if (stress) {
                setBarValue(stress, "#stress")
                $("#stressfull").fadeIn(500, function() { $("#stressfull").css("display", "flex"); });
            } else if (stress == false) {
                $("#stressfull").fadeOut(500, function() { $("#stressfull").css("display", "none"); });
            }
        }

        if (data.dogalgaz) {
            dogalgaz = data.dogalgaz
            setBarValue(dogalgaz, "#dogalgaz")
            $("#dogalgazfull").fadeIn(500, function() { $("#dogalgazfull").css("display", "flex"); });
        } else if (data.dogalgaz == false) {
            $("#dogalgazfull").fadeOut(500, function() { $("#dogalgazfull").css("display", "none"); });
        }

        if (yamert == false) {
            if (data.db) {
                db = data.db
                setBarValue(db, "#db")
                $("#dbfull").fadeIn(500, function() { $("#dbfull").css("display", "flex"); });
            } else if (data.db == false) {
                $("#dbfull").fadeOut(500, function() { $("#dbfull").css("display", "none"); });
            }
    
            if (data.wind) {
                wind = data.wind
                setBarValue(wind, "#wind")
                $("#windfull").fadeIn(500, function() { $("#windfull").css("display", "flex"); });
            } else if (data.wind == false) {
                $("#windfull").fadeOut(500, function() { $("#windfull").css("display", "none"); });
            }
    
            if (data.ampul) {
                ampul = data.ampul
                setBarValue(ampul, "#ampul")
                $("#ampulfull").fadeIn(500, function() { $("#ampulfull").css("display", "flex"); });
            } else if (data.ampul == false) {
                $("#ampulfull").fadeOut(500, function() { $("#ampulfull").css("display", "none"); });
            }
    
            if (data.dollar) {
                dollar = data.dollar
                setBarValue(dollar, "#dollar")
                $("#dollarfull").fadeIn(500, function() { $("#dollarfull").css("display", "flex"); });
            } else if (data.dollar == false) {
                $("#dollarfull").fadeOut(500, function() { $("#dollarfull").css("display", "none"); });
            }
    
            if (data.yuzme) {
                yuzme = data.yuzme
                setBarValue(yuzme, "#yuzme")
                $("#yuzmefull").fadeIn(500, function() { $("#yuzmefull").css("display", "flex"); });
            } else if (data.yuzme == false) {
                $("#yuzmefull").fadeOut(500, function() { $("#yuzmefull").css("display", "none"); });
            }
    
            if (data.gym) {
                yuzme = data.gym
                setBarValue(gym, "#gym")
                $("#gymfull").fadeIn(500, function() { $("#gymfull").css("display", "flex"); });
            } else if (data.gym == false) {
                $("#gymfull").fadeOut(500, function() { $("#gymfull").css("display", "none"); });
            }
        } else {
            $("#dbfull").fadeOut(500, function() { $("#dbfull").css("display", "none"); });
            $("#windfull").fadeOut(500, function() { $("#windfull").css("display", "none"); });
            $("#ampulfull").fadeOut(500, function() { $("#ampulfull").css("display", "none"); });
            $("#dollarfull").fadeOut(500, function() { $("#dollarfull").css("display", "none"); });
            $("#yuzmefull").fadeOut(500, function() { $("#yuzmefull").css("display", "none"); });
            $("#gymfull").fadeOut(500, function() { $("#gymfull").css("display", "none"); });
        }

        if (data.ping > 100) {
            ping = data.ping
            $("#pingfull").fadeIn(500, function() { $("#pingfull").css("display", "flex"); });
        } else if (data.ping < 100) {
            $("#pingfull").fadeOut(500, function() { $("#pingfull").css("display", "none"); });
        }

        if (data.harness) {
            harness = data.harness
            setBarValue(harness, "#harness")
            $("#harnessfull").fadeIn(500, function() { $("#harnessfull").css("display", "flex"); });
        } else if (data.harness == false) {
            $("#harnessfull").fadeOut(500, function() { $("#harnessfull").css("display", "none"); });
        }

        if (data.cruise) {
            cruise = data.cruise
            setBarValue(cruise, "#cruise")
            $("#cruisefull").fadeIn(500, function() { $("#cruisefull").css("display", "flex"); });
        } else if (data.cruise == false) {
            $("#cruisefull").fadeOut(500, function() { $("#cruisefull").css("display", "none"); });
        }

        if (data.nuke) {
            $("#nukefull").fadeIn(500, function() { $("#nukefull").css("display", "flex"); });
        } else if (data.nuke == false) {
            $("#nukefull").fadeOut(500, function() { $("#nukefull").css("display", "none"); });
        }

        if (data.dev) {
            $("#devmode").fadeIn(500, function() { $("#devmode").css("display", "flex"); });
        } else if (data.dev == false) {
            $("#devmode").fadeOut(500, function() { $("#devmode").css("display", "none"); });
        }

        if (data.debug) {
            $("#debugmode").fadeIn(500, function() { $("#debugmode").css("display", "flex"); });
        } else if (data.debug == false) {
            $("#debugmode").fadeOut(500, function() { $("#debugmode").css("display", "none"); });
        }

        if (data.armed) {
            $("#armed").fadeIn(500, function() { $("#armed").css("display", "flex"); });
        } else if (data.debug == false) {
            $("#armed").fadeOut(500, function() { $("#armed").css("display", "none"); });
        }

        if (data.gps) {
            $("#gpsfull").fadeIn(500, function() { $("#gpsfull").css("display", "flex"); });
        } else if (data.gps == false) {
            $("#gpsfull").fadeOut(500, function() { $("#gpsfull").css("display", "none"); });
        }

        if (data.gpu) {
            gpu = data.gpu
            setBarValue(gpu, "#gpu")
            $("#gpufull").fadeIn(500, function() { $("#gpufull").css("display", "flex"); });
        } else if (data.gpu == false) {
            $("#gpufull").fadeOut(500, function() { $("#gpufull").css("display", "none"); });
        }

        if (data.nos) {
            nos = data.nos
            setBarValue(nos, "#nos")
            $("#nosfull").fadeIn(500, function() { $("#nosfull").css("display", "flex"); });
        } else if (data.nos == false) {
            $("#nosfull").fadeOut(500, function() { $("#nosfull").css("display", "none"); });
        }

        //

        //




        if (data.health2 == "true") {
            $("#hearth-icon").css("color", "yellow");
        } else if (data.health2 == "false") {
            $("#hearth-icon").css("color", "white");
        }

        if (data.armor2 == "true") {
            $("#armor-icon").css("color", "yellow");
        } else if (data.armor2 == "false") {
            $("#armor-icon").css("color", "white");
        }

        if (data.hunger2 == "true") {
            $("#hunger-icon").css("color", "yellow");
        } else if (data.hunger2 == "false") {
            $("#hunger-icon").css("color", "white");
        }

        if (data.thirst2 == "true") {
            $("#thirst-icon").css("color", "yellow");
        } else if (data.thirst2 == "false") {
            $("#thirst-icon").css("color", "white");
        }

        if (data.oxy2 == "true") {
            $("#oxy-icon").css("color", "yellow");
        } else if (data.oxy2 == "false") {
            $("#oxy-icon").css("color", "white");
        }

        

        // komikmiş < 25

        if (health < 25) {
            $("#health").attr("stroke", "red");
            $("#healthbar").attr("stroke", "red");
        } else {
            $("#health").attr("stroke", "#3BB273");
            $("#healthbar").attr("stroke", "#3BB273");
        }
    
        if (armor < 25) {
            $("#armor").attr("stroke", "red");
            $("#armorbar").attr("stroke", "red");
        } else {
            $("#armor").attr("stroke", "#1565C0");
            $("#armorbar").attr("stroke", "#1565C0");
        }
    
        if (hunger < 25) {
            $("#hunger").attr("stroke", "red");
            $("#hungerbar").attr("stroke", "red");
        } else {
            $("#hunger").attr("stroke", "#FF6D00");
            $("#hungerbar").attr("stroke", "#FF6D00");
        }

        if (thirst < 25) {
            $("#thirst").attr("stroke", "red");
            $("#thirstbar").attr("stroke", "red");
        } else {
            $("#thirst").attr("stroke", "#0277BD");
            $("#thirstbar").attr("stroke", "#0277BD");
        }

        if (oxy < 25) {
            $("#oxy").attr("stroke", "red");
            $("#oxybar").attr("stroke", "red");
        } else {
            $("#oxy").attr("stroke", "#90A4AE");
            $("#oxybar").attr("stroke", "#90A4AE");
        }
    }
})

function mat(x){
    var deger = x;

    var partialValue = 126;

    var yuzde = 100/deger;

    var mat = partialValue/yuzde;

    var lastVal = partialValue - mat;
    return lastVal
}

document.onkeyup = function (data) {
    if ( data.which == 27 ) { //esc
      $.post('https://almin-hud/close', JSON.stringify({}));
      $(".menu").fadeOut(500);
    }
};

function setBarValue(value, element) {
    var matsa = mat(value);
    $(element).attr('stroke-dashoffset', matsa);
}



$(function(){
    $('.jss256').change(function(){
        if ($('.healthInput').prop('checked')) {
            health2 = false
        } else {
            health2 = true
        }

        if ($('.armorInput').prop('checked')) {
            armor2 = false
        } else {
            armor2 = true
        }

        if ($('.foodInput').prop('checked')) {
           hunger2 = false
        } else {
            hunger2 = true
        }

        if ($('.thirstInput').prop('checked')) {
            thirst2 = false
        } else {
            thirst2 = true
        }

        if ($('.oxyInput').prop('checked')) {
            oxy2 = false
        } else {
            oxy2 = true
        }

        if ($('.stressInput').prop('checked')) {
            stress2 = false
        } else {
            stress2 = true
        }

        if ($('.enhancementInput').prop('checked')) {
            yamert = true
        } else {
            yamert = false
        }

        if ($('.time').prop('checked')) {
            time = true;
        } else {
            time = false;
        }

        if ($('.streetInput').prop('checked')) {
            street = true;
        } else {
            street = false;
        }

        if ($('.blackbarInput').prop('checked')) {
            $('.blackbars').css({
                'display': 'block', 
                'height': $('.blackbarInputNumber').val() + 'vh'
            });

        } else {
            $('.blackbars').css('display', 'none')
        }
    });


    $('.blackbarInputNumber').keyup(function(){
        $('.blackbars').css('height', $(this).val() + 'vh')
    });

    $(".option-select").click(function() {
        let saveTxt =  $('.select-save-number div').html()
        console.log(saveTxt);

        if (saveTxt == '1') {
            if (data1.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }
        } else if (saveTxt == '2') {
            if (data2.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }
        }

    });

    $(".defaultmap").change(function() {
        if ($('.defaultmap').prop('checked')) {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "default"
            }));
        } else {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "ovalmap"
            }));
        }
    });

    $(".compass").change(function() {
        if ($('.compass').prop('checked')) {
            $('#compassfull').css("display", "block");
            compass = true
        } else {
            $('#compassfull').css("display", "none");
            compass = false
        }
    });

    $(".openmap").change(function() {
        if ($('.openmap').prop('checked')) {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "open"
            }));
            $('#speedometerfps').css("display", "block");
        } else {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "close"
            }));
            $('#speedometerfps').css("display", "none");
        }
    });

    $(".outlinemap").change(function() {
        if ($('.outlinemap').prop('checked')) {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "outline-open"
            }));
        } else {
            $.post('https://almin-hud/minimap', JSON.stringify({
                action: "outline-close"
            }));
        }
    });

    $(".menu").css("display", "none");
});


function pipidisabledSVG(input) {
    $(`${input}`).parent().parent().removeClass('Mui-checked')
    $(`${input} + svg path`).attr('d', 'M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z')
}

function pipicheckedSVG(input) {
    $(`${input}`).parent().parent().addClass('Mui-checked')
    $(`${input} + svg path`).attr('d', 'M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z')
}

function isElement(element) {
    return element instanceof Element || element instanceof HTMLDocument;
}

document.body.addEventListener('click', function(e) {

    let id = "myid",
    elemWidth = 15,
    elemHeight = 9,
    borderThickness = 1;

    let div = document.createElement("div");
    div.id = id;

    div.style.position = "absolute";
    div.style.height = `${elemHeight}vh`;
    div.style.width = `${elemWidth}vh`;
    div.style.display = "none";
  
    e.clientX + elemWidth + borderThickness * 50 > window.innerWidth
    ? (div.style.right = `${window.innerWidth - e.clientX}px`)
    : (div.style.left = `${e.clientX}px`);
    e.clientY + elemHeight + borderThickness * 20 > window.innerHeight
    ? (div.style.bottom = `${window.innerHeight - e.clientY}px`)
    : (div.style.top = `${e.clientY}px`);

    if (isElement(document.getElementById(id)))
    document.getElementById(id).remove();
    document.body.appendChild(div);
    $(`#${id}`).show();


    let saveOptionContainer = `
        <div class='option-container'>
            <div class='option-select save-option-1'><p>1</p></div>
            <div class='option-select save-option-2'><p>2</p></div>
        <div>
    `;

    let speedmeterOption = `
    <div class='option-container'>
        <div class='option-select speedmeter-15'><p>15</p></div>
        <div class='option-select speedmeter-35'><p>35</p></div>
        <div class='option-select speedmeter-60'><p>60</p></div>
    <div>
    `;

    let compassOption = `
    <div class='option-container'>
        <div class='option-select compass-15'><p>15</p></div>
        <div class='option-select compass-35'><p>35</p></div>
        <div class='option-select compass-60'><p>60</p></div>
    <div>
    `;


    //console.log(e.target)

    if ( $(e.target).is('.select-save-number div')) { 
        $(`#${id}`).append(saveOptionContainer);
        
    } else if ($(e.target).is('.speedmeterOptionBtn')) {
        $(`#${id}`).append(speedmeterOption);

        var posX = $(this).offset().left;
        if ((e.pageX - posX) > 955){
            $(`#${id}`).css('margin-left', '-14vh')
        }   

    } else if ($(e.target).is('.compassOptionBtn')) {
        $(`#${id}`).append(compassOption);
        var posX = $(this).offset().left;
        if ((e.pageX - posX) > 955){
            $(`#${id}`).css('margin-left', '-14vh')
        }   

    } else {
        $(`#${id}`).remove();
    }

    if ($(`#${id}`).css('display') == 'block') {
        $('.jss1239').css('overflow', 'hidden')
    } else {
        $('.jss1239').css('overflow-y', 'scroll')
    }



    $('.save-option-1').click(function(){
        $('.select-save-number div').html('1')

        let saveTxt =  $('.select-save-number div').html()


        if (saveTxt == '1') {
            if (data1.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }
        } else if (saveTxt == '2') {
            if (data2.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }
        }
    });
    $('.save-option-2').click(function(){
        $('.select-save-number div').html('2')

        let saveTxt =  $('.select-save-number div').html()

        if (saveTxt == '1') {
            if (data1.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }

            if (data1.armorInput == "true") {
                pipicheckedSVG('.armorInput')
            } else {
                pipidisabledSVG('.armorInput')
            }

            console.log(data1.armorInput)

            if (data1.hungerInput == "true") {
                pipicheckedSVG('.hungerInput')
            } else {
                pipidisabledSVG('.hungerInput')
            }

            if (data1.thirstInput == "true") {
                pipicheckedSVG('.thirstInput')
            } else {
                pipidisabledSVG('.thirstInput')
            }
        } else if (saveTxt == '2') {
            if (data2.healthInput == "true") {
                pipicheckedSVG('.healthInput')
            } else {
                pipidisabledSVG('.healthInput')
            }
        }
    });


    $('.speedmeter-15').click(function(){
        $('.speedmeterOptionBtn').html('15')
        $.post('https://almin-hud/carhud', JSON.stringify({
            fps: 500
        }));
    });
    $('.speedmeter-35').click(function(){
        $('.speedmeterOptionBtn').html('35')

        $.post('https://almin-hud/carhud', JSON.stringify({
            fps: 250
        }));
    });
    $('.speedmeter-60').click(function(){
        $('.speedmeterOptionBtn').html('60')
        $.post('https://almin-hud/carhud', JSON.stringify({
            fps: 50
        }));
    });


    $('.compass-15').click(function(){
        $('.compassOptionBtn').html('15')
        $.post('https://almin-hud/compass', JSON.stringify({
            fps: 750
        }));
    });
    $('.compass-35').click(function(){
        $('.compassOptionBtn').html('35')
        $.post('https://almin-hud/compass', JSON.stringify({
            fps: 150
        }));
    });
    $('.compass-60').click(function(){
        $('.compassOptionBtn').html('60')
        $.post('https://almin-hud/compass', JSON.stringify({
            fps: 50
        }));
    });




    return false;
});

const checkboxs = document.getElementsByClassName('jss256');
const inputColor = document.getElementsByClassName('MuiIconButton-root');
const inputSvg = document.querySelectorAll('.MuiIconButton-root .MuiIconButton-label .MuiSvgIcon-root path');
setTimeout(() => {
    for (let i = 0; i < checkboxs.length; i++) {
        checkboxs[i].addEventListener('change', function(){
            if (checkboxs[i].checked) {
                //console.log(checkboxs[i])
                inputColor[i].classList.add('Mui-checked')
                inputSvg[i].setAttribute('d', 'M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z')
        
            } else {
                inputColor[i].classList.remove('Mui-checked')
                inputSvg[i].setAttribute('d', 'M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z')
            }
        });
    }        
}, 1);


