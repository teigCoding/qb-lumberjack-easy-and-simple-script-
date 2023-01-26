local Translations = {
    error = {
        no_axe = "You are not holding an axe!",
        already_cut = "You have already cut the tree!",
        no_logs = "You have no logs!",
        nothing_tosell = "You have nothing to sell!",
    },
    success = {
        sell = " resources sold for ",
    },
    label = {
        cutting = "Cutting the tree..",
        selling = "Selling Rrsources..",
        processing = "Tearing off the bark..",
        header = "Sell Materials",
        header2 = "Timber",
        header2_1 = "Simple Timber",
        header3 = "Planks",
        header3_1 = "Processed timber",
        sell_resources = "Sell Resources",
        cut = "Cut",
        process = 'Tear off bark',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

