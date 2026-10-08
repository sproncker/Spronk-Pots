CreateConVar("spronk_growthf_boost", "1.15", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- 15% faster default (deduction of time on grow)
CreateConVar("spronk_growlamp_boost", "1.15", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- 15% faster default grow lamp boost

CreateConVar("spronk_weed_ent", "spronk_bud", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_weed_growtime", "500", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_weed_interval", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_weed_hmin", "3", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- minimum harvest amount
CreateConVar("spronk_weed_hmax", "6", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})  -- maximum harvest amount
CreateConVar("spronk_weed_value", "100", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- value per coca harvested
CreateConVar("spronk_weed_usesell", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Whether to use Weed Entities to sell them.")

CreateConVar("spronk_coca_ent", "spronk_cocaine", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_coca_growtime", "5", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_coca_interval", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
CreateConVar("spronk_coca_hmin", "2", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- minimum harvest amount
CreateConVar("spronk_coca_hmax", "6", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})  -- maximum harvest amount
CreateConVar("spronk_coca_value", "250", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}) -- value per coca harvested
CreateConVar("spronk_coca_usesell", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Whether to use Coca Entities to sell them.")