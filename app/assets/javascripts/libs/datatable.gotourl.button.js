TableTools.BUTTONS.gotoURL = {
    "sAction": "text",
    "sFieldBoundary": "",
    "sFieldSeperator": "\t",
    "sNewLine": "<br>",
    "sToolTip": "",
    "sButtonClass": "",
    "sButtonClassHover": "",
    "sButtonText": "Go to URL", // default, change when initiating
    "sGoToURL": "", // default, change when initiating
    "mColumns": "all",
    "bHeader": true,
    "bFooter": true,
    "fnMouseover": null,
    "fnMouseout": null,
    "fnClick": function( nButton, oConfig ) {
        location.href = oConfig.sGoToURL;
    },
    "fnSelect": null,
    "fnComplete": null,
    "fnInit": null
};
