local Translations = {
    error = {
        no_axe = "Du holder ikke en øks!",
        already_cut = "Du har allerede hogget treet!",
        no_logs = "Du har ikke tømmer!",
        nothing_tosell = "Du har ingenting du kan selge!",
    },
    success = {
        sell = " ressurser solgt for ",
    },
    label = {
        cutting = "Hogger treet..",
        selling = "Selger ressurser",
        processing = "River av barken",
        header = "Selg Materialer",
        header2 = "Tømmer",
        header2_1 = "Enkel tømmer",
        header3 = "Planker",
        header3_1 = "Prosessert tømmer",
        sell_resources = "Selg ressurser",
        cut = "Hogg",
        process = 'Riv av bark',      
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
