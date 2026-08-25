---@diagnostic disable: undefined-global

return {
  s("date", t(os.date("%d.%m.%Y"))),
  s("isodate", t(os.date("%Y-%m-%d"))),
  s("mail", t("vilho.luoma@gmail.com")),
  s("wmail", t("vilho.luoma@futurice.com")),
}
