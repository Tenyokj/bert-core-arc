// SPDX-License-Identifier: GPL-3.0
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@#▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇##########################▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@@#▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇#######%********************%#####@#▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▁@###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####%%******%#################%******%####@▇▇▇▇▇▇▇▇▇▇▇@####▓▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▓######▇▇▇▇▇▇▇▇▇█#####*****##############################*****%####▇▇▇▇▇▇@######▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@##%####@▇▇▇▇#####****######################################****#####▇#####%##@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@##**%###▇@###%***############################################***%######**##@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###***#####***%########################*#######################%*%###***###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###%****%#############################%**##########################%****##@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###%*****%#######################%##*%**%##%#####################*****###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####*******%###############%%****##%%%***%##****%##############******%#####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇█######********##%######%*********##%%%%****%#%********%#####%##*******###%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###*###%*******%#%***###%********##*%%%%*****%#%*******###%**##*******###***###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###**%###%*******##*****###******##%*%%%%%*****%#%****%##****%#%*******####***####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###**%#####%*******##%**###******##%*%%%%%*******##%*****##%**##*******######%**####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####**%########*******##%##%******##%*%%%######%****##%*****#####******%########%**###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###**%###########%*****###******%##%*##############%*###*****%##*****%###########%**###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###***#####@#########****%##%****########################%***###****%##############***@##▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###**######**%%##%*%###%***###****%##%%%###########%*%##****##%**%###%**###%**%#####**%##@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###**%########%***%#%**%###%*%##%***%###%***%###%***%###***%##*%###%***%%****%#######%**###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###%**%###########%*********%######****####%********###%***######%*********%###########**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###%**###############%*********%####%***#####*****####%**%####%*********%##############%**###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇##@**%##########**%######%********%###***%#####*#####***%##%********%#####%**###########**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###**%#########*****#########%************%#########***%*********%########****##########**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###**#########%****#########%###%***********#######**********%###%########%***%#########**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####**#########*****@##%#####****%###%********####%*******%###%****%########****%########***###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####**########******###*#####%*******####%*****%#******%####*******%###%%##%*****########***###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####**%######%*******##*%######****%#########%*****%#########%***%#####*###*******#######**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇##@***######********###**######################%####################%**##%*******#######**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇###%**#######********%##**%##############%%%%%###%**%#############%***##********#######%**%###▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@##%**%#######*********###%********%####%%%%%%%******%####%%*******%##%*******%########%**####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###***@########%*********%%######%%**###%%%%%%*****%###%*%%######%*********%##########***###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###**%#####*####%*****************###%##%%%%%*****######%***************%####*%#####%**####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###***####%**%######%**********%##%***###%%%%****###%***###*********%######%***#####***###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▓####***####****##########@######*******###%%%***%###******%#####@#########%***%####***@###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇####***####****%###%##########%********###%%%*%###********#########%%###****%###@***%###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###%***######%**##%%%%%########%*******##%%**###******%########%%%%##%*%#@#####***%###@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@###%***############%%%%%%#######%*****%##%%###*****%######%%%%%%########%####***%####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇#####***####******%#####%%%%%######****%#####****%#####%%%%%#####%******####***%####@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####***%###%******%####%%%%%%%#####%**%###%**######%%%%%#####*******####%***#####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####%***####%*******####%%%%%##%%####%##%%###%*##%%%%%####*******%####***%#####▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####****####%*******####%%%%##%%%%######%***%##%%%###%*******%####****#####@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####%****#####******#%####%##%%%%%%%%******##%%#####%*****#####****%####@@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@####%****######***##**######%%%%%%******%#####%*%#***%#####****%#####@#▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇######*****########****######%%%%*****#####%***##%#####%****%######@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇#######%*****######*****######%%***%####%****######%****%#######@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@#####@%*****%####%****#####%*%#####****%###%******########@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇#@#######%****####%****#########****####*****%#########▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇##########%*######***%#####***%#####%%#@########@█▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@##############@%**%#***%################@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇@@@############***#############@#@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇#@@###############@▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
// ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇    
/**
 *     NOTICE
 *
 *     BERT is an upgradeable DAO voting and grant protocol developed to turn
 *     community ideas into funded on-chain outcomes. The protocol enables users
 *     to submit ideas, participate in structured voting rounds with stake, and
 *     receive transparent grant distribution through upgradeable smart contracts
 *     on EVM-compatible blockchains.
 *
 *     Copyright (C) 2026, BERT contributors.
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program. If not, see <https://www.gnu.org/licenses/>.
 */
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { RolesAwareUpgradeable } from "../extensions/Roles/RolesAwareUpgradeable.sol";
import { IFundingPool } from "../interfaces/IFundingPool.sol";
import { IIdeaRegistry } from "../interfaces/IIdeaRegistry.sol";
import { ICommunityFactoryRegistry } from "../interfaces/ICommunityFactoryRegistry.sol";
import "../utils/Errors.sol";

/**
 * @title FundingPool
 * @notice Manages USDC deposits and distributes grants to winning ideas
 * @dev Handles donor balances, fund safekeeping, and controlled distribution
 * @dev Pausable, Upgradeable
 * 
 * @custom:version 1.2.0
 */
contract FundingPoolUpgradeable is 
    Initializable, 
    ReentrancyGuardUpgradeable, 
    PausableUpgradeable, 
    RolesAwareUpgradeable, 
    IFundingPool 
{
    using SafeERC20 for IERC20;

    /* ========== CONTRACTS ========== */ 

    /// @notice USDC contract used for all treasury flows
    IERC20 public usdc;
    
    /// @notice IdeaRegistry contract address for author verification
    IIdeaRegistry public ideaRegistry;

    /* ========== STATE VARIABLES ========== */

    /// @notice Total tokens held in the pool
    uint256 public totalPoolBalance;
    
    /// @notice Protocol reserve retained after distributions
    uint256 public protocolReserve;

    /* ========== STRUCTS ========== */

    /**
     * @notice Structure representing a fund distribution record
     * @param roundId Identifier of the funding round
     * @param ideaId Identifier of the winning idea
     * @param amount Amount of tokens distributed
     * @param distributedAt Timestamp when distribution occurred
     */
    struct Distribution {
        uint256 roundId;
        uint256 ideaId;
        uint256 amount;
        uint256 distributedAt;
    }

    /* ========== STORAGE ========== */

    /// @notice Mapping from donor address to their deposited amount
    mapping(address => uint256) public donorBalances;

    /// @notice Mapping of pool history for Round & ideas: roundId => ideaId => amount
    mapping(uint256 => mapping(uint256 => uint256)) public _poolByRoundAndIdea;

    /// @dev Array of all historical distributions
    Distribution[] public distributionHistory;
    
    /// @dev Mapping from round ID to distribution status
    mapping(uint256 => bool) public distributed;

    /// @notice Mapping from idea ID to locked author stake amount
    /// @dev Tracks per-idea author deposits in 6-decimal USDC units.
    mapping(uint256 => uint256) public authorStakeByIdea;

    /// @notice BERT V3 Factory authorized to authenticate CommunityTreasury reserve inflows
    address public communityFactory;

    /// @dev Individual pledge data is deliberately separate from donor balances.
    struct Pledge {
        uint256 ideaId;
        uint256 amount;
        bool refundClaimed;
    }

    /// @notice Pledge fee in basis points, charged only when a round funds a winner.
    uint256 public pledgeFeeBps;

    /// @notice Funding-round lifecycle and selected winner.
    mapping(uint256 => bool) public fundingRoundOpened;
    mapping(uint256 => bool) public fundingRoundSettled;
    mapping(uint256 => uint256) public fundingRoundWinner;

    /// @notice Immutable fee snapshots, one per opened funding round.
    mapping(uint256 => uint256) public fundingRoundFeeBps;

    /// @notice One wallet may have exactly one refundable pledge in one funding round.
    mapping(uint256 => mapping(address => Pledge)) private pledges;

    /// @notice Fee held in escrow until the winning author actually starts the grant.
    mapping(uint256 => uint256) public pendingProtocolFeeByRound;
    mapping(uint256 => bool) public fundingRoundFeeFinalized;
    mapping(uint256 => bool) public fundingRoundCancelled;
    mapping(uint256 => bool) public grantRefundActive;
    mapping(uint256 => uint256) public winningGrossPledgeByRound;
    mapping(uint256 => uint256) public winningPledgeCountByRound;
    mapping(uint256 => uint256) public grantRefundTotalByRound;
    mapping(uint256 => uint256) public grantRefundPaidByRound;
    mapping(uint256 => uint256) public grantRefundClaimCountByRound;
    mapping(uint256 => mapping(uint256 => uint256)) private _pledgeCountByRoundAndIdea;

    /* ========== INITIALIZE ========== */

    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the FundingPool contract
     * @param _usdc USDC contract address
     * @param _ideaRegistry IdeaRegistry contract address
     * @custom:emits FundingPoolInitialized
     * @custom:requires All addresses must be non-zero
     */
    function initialize(
        address _usdc,
        address _ideaRegistry,
        address _rolesRegistry
    ) public initializer {
        __ReentrancyGuard_init();
        __Pausable_init();

        if (_rolesRegistry == address(0)) revert ZeroAddress("rolesRegistry");

        __RolesAware_init(_rolesRegistry);

        // BERT V2 starts with a transparent 5% success fee; each round snapshots it on open.
        pledgeFeeBps = 500;
        
        if (_usdc == address(0)) revert ZeroAddress("usdc");
        if (_ideaRegistry == address(0)) revert ZeroAddress("ideaRegistry");

        usdc = IERC20(_usdc);
        ideaRegistry = IIdeaRegistry(_ideaRegistry);
        
        _pause();
        
        emit FundingPoolInitialized(msg.sender);
    }

    /**
     * @notice Initializes conditional-pledge configuration on an already initialized legacy proxy.
     * @dev `initialize` cannot run during a proxy upgrade, so this one-time migration sets the
     *      first fee used by newly opened rounds without touching existing pool accounting.
     */
    function initializeConditionalPledges(uint256 initialFeeBps) external reinitializer(2) onlyAdmin {
        if (initialFeeBps > 1_000) revert InvalidParameter("initialFeeBps", "above 10 percent");
        pledgeFeeBps = initialFeeBps;
        emit PledgeFeeUpdated(initialFeeBps);
    }

    /* ========== EXTERNAL FUNCTIONS ========== */

    /**
     * @notice Deposits USDC into the funding pool
     * @dev Transfers tokens from caller to contract, updates donor balance
     * @param amount Amount of tokens to deposit
     * @custom:emits FundsDeposited
     * @custom:emits PoolBalanceUpdated
     * @custom:requires amount > 0
     * @custom:reentrancy protected
     */
    function deposit(uint256 amount) external nonReentrant whenNotPaused {
        if (amount == 0) {
            revert ZeroAmount();
        }
        
        usdc.safeTransferFrom(msg.sender, address(this), amount);

        donorBalances[msg.sender] += amount;
        totalPoolBalance += amount;

        emit FundsDeposited(msg.sender, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /**
     * @notice Pulls USDC routed by an active BERT V3 CommunityTreasury into protocol reserve
     * @dev Unlike `deposit`, this does not create a donor balance because V3 outcomes are protocol revenue.
     * @param amount Amount of USDC to move from the calling CommunityTreasury
     * @custom:requires V3 Factory configured and caller is an activated Treasury in that Factory
     */
    function receiveCommunityReserve(uint256 amount) external nonReentrant whenNotPaused {
        if (amount == 0) revert ZeroAmount();
        if (communityFactory == address(0)) revert CommunityFactoryNotConfigured();
        if (!ICommunityFactoryRegistry(communityFactory).isActiveCommunityTreasury(msg.sender)) {
            revert UnauthorizedCommunityTreasury(msg.sender);
        }

        usdc.safeTransferFrom(msg.sender, address(this), amount);
        totalPoolBalance += amount;
        protocolReserve += amount;

        emit CommunityReserveReceived(msg.sender, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /**
     * @notice Deposits author stake for a newly created idea
     * @dev Can only be called by the IdeaRegistry contract.
     *      This is separate from voter deposits because the amount is locked
     *      against the idea itself and can later be slashed into `protocolReserve`
     *      if the idea is rejected.
     * @param from Address from which tokens are transferred
     * @param ideaId ID of the idea being created
     * @param amount Amount of tokens to deposit
     */
    function depositAuthorStakeFrom(
        address from,
        uint256 ideaId,
        uint256 amount
    ) external onlyIdeaRegistry nonReentrant {
        if (from == address(0)) {
            revert ZeroAddress("from");
        }
        if (ideaId == 0) {
            revert InvalidId("ideaId");
        }
        if (amount == 0) {
            revert ZeroAmount();
        }

        usdc.safeTransferFrom(from, address(this), amount);

        donorBalances[from] += amount;
        authorStakeByIdea[ideaId] += amount;
        totalPoolBalance += amount;

        emit AuthorStakeDeposited(ideaId, from, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /**
     * @notice Opens the escrow ledger for one funding round.
     * @dev The voting system calls this before any user can deposit a pledge.
     */
    function openFundingRound(uint256 roundId) external onlyVotingSystem {
        if (roundId == 0 || fundingRoundOpened[roundId]) revert FundingRoundStateInvalid(roundId);

        fundingRoundOpened[roundId] = true;
        fundingRoundFeeBps[roundId] = pledgeFeeBps;
        emit FundingRoundOpened(roundId, pledgeFeeBps);
    }

    /**
     * @notice Pulls and records a refundable pledge made through a funding round.
     */
    function recordPledgeFrom(
        address from,
        uint256 roundId,
        uint256 ideaId,
        uint256 amount
    ) external onlyVotingSystem nonReentrant whenNotPaused {
        if (from == address(0)) revert ZeroAddress("from");
        if (ideaId == 0) revert InvalidId("ideaId");
        if (amount == 0) revert ZeroAmount();
        if (roundId == 0 || !fundingRoundOpened[roundId] || fundingRoundSettled[roundId]) {
            revert FundingRoundStateInvalid(roundId);
        }
        if (pledges[roundId][from].amount != 0) revert FundingRoundStateInvalid(roundId);

        usdc.safeTransferFrom(from, address(this), amount);
        pledges[roundId][from] = Pledge({
            ideaId: ideaId,
            amount: amount,
            refundClaimed: false
        });
        totalPoolBalance += amount;
        _poolByRoundAndIdea[roundId][ideaId] += amount;
        _pledgeCountByRoundAndIdea[roundId][ideaId] += 1;

        emit FundsDeposited(from, amount);
        emit PledgeRecorded(roundId, ideaId, from, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /**
     * @notice Settles a funding round, retaining the configured fee only from its winner.
     * @dev A zero winner makes every recorded pledge refundable.
     */
    function settleFundingRound(
        uint256 roundId,
        uint256 winningIdeaId
    ) external onlyVotingSystem nonReentrant {
        if (!fundingRoundOpened[roundId] || fundingRoundSettled[roundId]) {
            revert FundingRoundStateInvalid(roundId);
        }
        fundingRoundSettled[roundId] = true;
        fundingRoundWinner[roundId] = winningIdeaId;

        if (winningIdeaId == 0) {
            emit FundingRoundSettled(roundId, 0, 0, 0, 0);
            return;
        }

        uint256 grossFunding = _poolByRoundAndIdea[roundId][winningIdeaId];
        uint256 fee = (grossFunding * fundingRoundFeeBps[roundId]) / 10_000;
        uint256 netFunding = grossFunding - fee;
        _poolByRoundAndIdea[roundId][winningIdeaId] = netFunding;
        pendingProtocolFeeByRound[roundId] = fee;
        winningGrossPledgeByRound[roundId] = grossFunding;
        winningPledgeCountByRound[roundId] = _pledgeCountByRoundAndIdea[roundId][winningIdeaId];
        emit FundingRoundSettled(roundId, winningIdeaId, grossFunding, fee, netFunding);
    }

    /** @notice Finalizes a successful-round fee only after its author claims the grant. */
    function finalizeFundingRoundFee(uint256 roundId) external onlyDistributor nonReentrant {
        uint256 winner = fundingRoundWinner[roundId];
        if (!fundingRoundSettled[roundId] || winner == 0 || fundingRoundCancelled[roundId]) {
            revert FundingRoundStateInvalid(roundId);
        }
        if (fundingRoundFeeFinalized[roundId]) revert FundingRoundStateInvalid(roundId);

        uint256 fee = pendingProtocolFeeByRound[roundId];
        pendingProtocolFeeByRound[roundId] = 0;
        fundingRoundFeeFinalized[roundId] = true;
        protocolReserve += fee;

        emit IdeaFundsReserved(roundId, winner, fee);
        emit FundingRoundFeeFinalized(roundId, fee);
    }

    /** @notice Makes a never-claimed winning pledge fully refundable, including its pending fee. */
    function cancelUnclaimedFundingRound(uint256 roundId) external onlyDistributor nonReentrant {
        uint256 winner = fundingRoundWinner[roundId];
        if (!fundingRoundSettled[roundId] || winner == 0 || fundingRoundFeeFinalized[roundId]) {
            revert FundingRoundStateInvalid(roundId);
        }
        if (fundingRoundCancelled[roundId]) revert FundingRoundStateInvalid(roundId);

        uint256 restoredFee = pendingProtocolFeeByRound[roundId];
        pendingProtocolFeeByRound[roundId] = 0;
        fundingRoundCancelled[roundId] = true;
        _poolByRoundAndIdea[roundId][winner] += restoredFee;

        emit FundingRoundCancelled(roundId, winner, restoredFee);
    }

    /** @notice Opens proportional refunds for the unspent portion of an expired live grant. */
    function activateGrantRefund(uint256 roundId) external onlyDistributor nonReentrant {
        uint256 winner = fundingRoundWinner[roundId];
        if (!fundingRoundFeeFinalized[roundId] || fundingRoundCancelled[roundId] || winner == 0) {
            revert FundingRoundStateInvalid(roundId);
        }
        if (grantRefundActive[roundId]) revert FundingRoundStateInvalid(roundId);

        uint256 refundTotal = _poolByRoundAndIdea[roundId][winner];
        grantRefundActive[roundId] = true;
        grantRefundTotalByRound[roundId] = refundTotal;

        emit GrantRefundActivated(roundId, winner, refundTotal);
    }

    /**
     * @notice Returns a losing pledge, a fully cancelled winning pledge, or an expired grant remainder.
     */
    function claimPledgeRefund(uint256 roundId) external nonReentrant whenNotPaused returns (uint256 amount) {
        if (!fundingRoundSettled[roundId]) revert PledgeRefundUnavailable(roundId, msg.sender);

        Pledge storage pledge = pledges[roundId][msg.sender];
        if (pledge.amount == 0) {
            revert PledgeRefundUnavailable(roundId, msg.sender);
        }
        if (pledge.refundClaimed) revert PledgeRefundAlreadyClaimed(roundId, msg.sender);

        uint256 winner = fundingRoundWinner[roundId];
        if (pledge.ideaId == winner) {
            if (fundingRoundCancelled[roundId]) {
                amount = pledge.amount;
            } else if (grantRefundActive[roundId]) {
                uint256 claimantCount = grantRefundClaimCountByRound[roundId] + 1;
                if (claimantCount == winningPledgeCountByRound[roundId]) {
                    amount = grantRefundTotalByRound[roundId] - grantRefundPaidByRound[roundId];
                } else {
                    amount = (grantRefundTotalByRound[roundId] * pledge.amount) / winningGrossPledgeByRound[roundId];
                }
                grantRefundClaimCountByRound[roundId] = claimantCount;
                grantRefundPaidByRound[roundId] += amount;
            } else {
                revert PledgeRefundUnavailable(roundId, msg.sender);
            }
        } else {
            amount = pledge.amount;
        }

        pledge.refundClaimed = true;
        _poolByRoundAndIdea[roundId][pledge.ideaId] -= amount;
        totalPoolBalance -= amount;
        usdc.safeTransfer(msg.sender, amount);

        emit PledgeRefundClaimed(roundId, pledge.ideaId, msg.sender, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /// @notice Previews the amount remaining for the author after the configured pledge fee.
    function previewNetFunding(uint256 grossAmount) external view returns (uint256) {
        return grossAmount - ((grossAmount * pledgeFeeBps) / 10_000);
    }

    /// @notice Previews net funding with the fee fixed when this round opened.
    function previewRoundNetFunding(uint256 roundId, uint256 grossAmount) external view returns (uint256) {
        return grossAmount - ((grossAmount * fundingRoundFeeBps[roundId]) / 10_000);
    }

    function getFundingRoundSettlement(uint256 roundId)
        external
        view
        returns (bool opened, bool settled, uint256 winningIdeaId)
    {
        return (fundingRoundOpened[roundId], fundingRoundSettled[roundId], fundingRoundWinner[roundId]);
    }

    function getPledge(uint256 roundId, address voter)
        external
        view
        returns (uint256 ideaId, uint256 amount, bool refundClaimed)
    {
        Pledge storage pledge = pledges[roundId][voter];
        return (pledge.ideaId, pledge.amount, pledge.refundClaimed);
    }

    /** @notice Configures the successful-round fee; 10% is the hard safety ceiling. */
    function setPledgeFeeBps(uint256 feeBps) external onlyAdmin {
        if (feeBps > 1_000) revert InvalidParameter("feeBps", "above 10 percent");
        pledgeFeeBps = feeBps;
        emit PledgeFeeUpdated(feeBps);
    }

    /**
     * @notice Distributes funds to a winning idea (only distributor role can call)
     * @dev Transfers tokens to idea author, records distribution
     * @param roundId Grant round identifier
     * @param ideaId Winning idea identifier
     * @param amount Amount to distribute
     * @custom:emits FundsDistributed
     * @custom:emits PoolBalanceUpdated
     * @custom:requires Only addresses with GRANT_ROLE can call
     * @custom:requires round not previously distributed
     * @custom:requires amount > 0 and ≤ pool balance for that idea in the round
     * @custom:reentrancy protected
     */
    function distributeFunds(
        uint256 roundId,
        uint256 ideaId,
        uint256 amount
    ) external 
      onlyDistributor
      nonReentrant 
      whenNotPaused 
    {
        if (amount == 0) {
            revert ZeroAmount();
        }
        
        address author = ideaRegistry.getIdeaAuthor(ideaId);
        if (author == address(0)) {
            revert InvalidAuthor();
        }

        uint256 available = _poolByRoundAndIdea[roundId][ideaId];
        if (amount > available) {
            revert InsufficientIdeaBalance(roundId, ideaId, available, amount);
        }

        uint256 remaining = available - amount;
        _poolByRoundAndIdea[roundId][ideaId] = remaining;
        totalPoolBalance -= amount;
        if (remaining == 0) {
            distributed[roundId] = true;
        }
        
        distributionHistory.push(Distribution({
            roundId: roundId,
            ideaId: ideaId,
            amount: amount,
            distributedAt: block.timestamp
        }));

        usdc.safeTransfer(author, amount);

        emit FundsDistributed(roundId, ideaId, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /**
     * @notice Slashes an author's stake into protocol reserve
     * @dev Can only be called by the IdeaRegistry contract.
     *      If the stake is already zero, the function exits silently so repeated
     *      rejection handling does not break downstream state transitions.
     * @param ideaId ID of the rejected idea
     */
    function slashAuthorStakeToReserve(uint256 ideaId) external onlyIdeaRegistry {
        if (ideaId == 0) {
            revert InvalidId("ideaId");
        }

        uint256 amount = authorStakeByIdea[ideaId];
        if (amount == 0) {
            return;
        }

        authorStakeByIdea[ideaId] = 0;
        protocolReserve += amount;

        emit AuthorStakeSlashed(ideaId, amount);
    }

    /** @notice Releases the author bond once a winning proposal starts its grant lifecycle. */
    function releaseAuthorStakeToAuthor(uint256 ideaId) external onlyIdeaRegistry nonReentrant {
        uint256 amount = authorStakeByIdea[ideaId];
        if (amount == 0) return;

        address author = ideaRegistry.getIdeaAuthor(ideaId);
        if (author == address(0)) revert InvalidAuthor();

        authorStakeByIdea[ideaId] = 0;
        donorBalances[author] -= amount;
        totalPoolBalance -= amount;
        usdc.safeTransfer(author, amount);
        emit AuthorStakeReleased(ideaId, author, amount);
        emit PoolBalanceUpdated(totalPoolBalance);
    }

    /* ========== VIEW FUNCTIONS ========== */

    /**
     * @notice Returns the total number of distributions made
     * @return count Number of distribution records
     */
    function getDistributionCount() external view returns (uint256) {
        return distributionHistory.length;
    }

    /**
     * @notice Returns distribution details by index
     * @param index Position in distributionHistory array
     * @return roundId Grant round identifier
     * @return ideaId Winning idea identifier
     * @return amount Distributed amount
     * @return distributedAt Distribution timestamp
     * @custom:requires index must be within bounds
     */
    function getDistribution(uint256 index) external view returns (
        uint256 roundId,
        uint256 ideaId,
        uint256 amount,
        uint256 distributedAt
    ) {
        if (index >= distributionHistory.length) {
            revert IndexOutOfBounds();
        }
        Distribution memory d = distributionHistory[index];
        return (d.roundId, d.ideaId, d.amount, d.distributedAt);
    }

    /**
     * @notice Checks if funds have been distributed for a specific round
     * @param roundId The ID of the round to check
     * @return bool True if funds have been distributed for this round, false otherwise
     * @custom:requires roundId > 0
     */
    function isDistributed(uint256 roundId) external view returns (bool) {
        if (roundId == 0) {
            revert InvalidId("roundId");
        }
        return distributed[roundId];
    }

    /**
     * @notice Gets the pool balance for a specific idea in a specific round
     * @param roundId The ID of the round
     * @param ideaId The ID of the idea
     * @return uint256 The amount of tokens allocated to this idea in this round
     * @custom:requires roundId > 0
     * @custom:requires ideaId > 0
     */
    function poolByRoundAndIdea(uint256 roundId, uint256 ideaId) external view returns (uint256) {
        if (roundId == 0) {
            revert InvalidId("roundId");
        }
        if (ideaId == 0) {
            revert InvalidId("ideaId");
        }
        return _poolByRoundAndIdea[roundId][ideaId];
    }

    /* =========== ADMIN FUNCTIONS =========== */
    
    /**
     * @notice Allocates protocol reserve to a specific round/idea
     * @dev Only callable by the admin
     * @param roundId The ID of the round
     * @param ideaId The ID of the idea
     * @param amount Amount of reserve to allocate
     */
    function allocateReserveToIdea(uint256 roundId, uint256 ideaId, uint256 amount) external onlyAdmin {
        if (roundId == 0) {
            revert InvalidId("roundId");
        }
        if (ideaId == 0) {
            revert InvalidId("ideaId");
        }
        if (amount == 0) {
            revert ZeroAmount();
        }
        if (amount > protocolReserve) {
            revert InsufficientPoolBalance(protocolReserve, amount);
        }

        protocolReserve -= amount;
        _poolByRoundAndIdea[roundId][ideaId] += amount;
        emit ProtocolReserveAllocated(roundId, ideaId, amount);
    }
    
    /**
     * @notice Returns the deprecated governance-token compatibility getter
     * @dev Older integrations still expect `governanceToken()`, but the protocol
     *      now settles exclusively in USDC.
     */
    function governanceToken() external view returns (IERC20 token) {
        return usdc;
    }

    /**
     * @notice Updates the USDC contract address
     * @dev Can only be called by the contract admin
     * @param _newToken New USDC token address
     * @custom:emits UsdcUpdated
     * @custom:emits GovernanceTokenUpdated
     * @custom:requires _newToken cannot be zero address
     */
    function setUsdc(address _newToken) public onlyAdmin {
        if (_newToken == address(0)) {
            revert ZeroAddress("newToken");
        }
        usdc = IERC20(_newToken);
        emit UsdcUpdated(_newToken);
        emit GovernanceTokenUpdated(_newToken);
    }

    /**
     * @notice Deprecated compatibility setter retained for older tooling
     * @param _newToken New USDC token address
     */
    function setGovernanceToken(address _newToken) external onlyAdmin {
        setUsdc(_newToken);
    }

    /**
     * @notice Updates the idea registry contract address
     * @dev Can only be called by the contract admin
     * @param _newRegistry New idea registry address
     * @custom:emits IdeaRegistryUpdated
     * @custom:requires _newRegistry cannot be zero address
     */
    function setIdeaRegistry(address _newRegistry) external onlyAdmin {
        if (_newRegistry == address(0)) {
            revert ZeroAddress("newRegistry");
        }
        ideaRegistry = IIdeaRegistry(_newRegistry);
        emit IdeaRegistryUpdated(_newRegistry);
    }

    /**
     * @notice Configures the BERT V3 CommunityFactory that authenticates reserve contributors
     * @param _communityFactory Factory address for active CommunityTreasury validation
     */
    function setCommunityFactory(address _communityFactory) external onlyAdmin {
        if (_communityFactory == address(0)) {
            revert ZeroAddress("communityFactory");
        }

        communityFactory = _communityFactory;
        emit CommunityFactoryUpdated(_communityFactory);
    }

    /**
     * @notice Checks real pool balance
     * @dev Can only be called by the contract admin.
     *      Reconciles `totalPoolBalance` with the actual token balance while keeping
     *      `protocolReserve` accounted for separately.
     */
    function syncBalance() external onlyAdmin {
        uint256 real = usdc.balanceOf(address(this));
        totalPoolBalance = real - protocolReserve;
    }

    /* ========== PAUSE FUNCTIONS ========== */

    /**
     * @notice Emergency pause the voting system
     * @dev Only admin can pause. Stops all critical operations.
     * @custom:requires Only admin can call
     */
    function pause() external onlyAdmin {
        _pause();
    }

    /**
     * @notice Unpause the voting system
     * @dev Only admin can unpause. Resumes normal operations.
     * @custom:requires Only admin can call
     */
    function unpause() external onlyAdmin {
        _unpause();
    }

    /**
     * @notice Check if contract is paused
     * @return bool True if contract is paused
     */
    function isPaused() external view returns (bool) {
        return paused();
    }

    /* ========== UPGRADE SAFETY ========== */

    /**
     * @notice Storage gap for future upgrades
     * @dev Reserved storage space to allow for new variables in upgrades
     * @dev Prevents storage collisions when adding new state variables
     * 
     * @custom:upgrade-safety Reserve slots after newly added variables when upgrading
     * @custom:warning Do not reorder existing storage variables in future versions
     */
    uint256[33] private __gap;
}
