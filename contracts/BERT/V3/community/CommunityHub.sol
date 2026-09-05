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
 *     BERT V3 is the Community Layer of the BERT protocol, designed to enable
 *     independent on-chain communities to turn proposals into transparent,
 *     stake-backed decisions and route resulting capital automatically.
 *
 *     Each community operates through its own governance infrastructure,
 *     including stake-gated membership, administrators, validators, proposal
 *     validation, USDC-backed binary voting, community treasury management,
 *     and integration with the global BERT reserve.
 *
 *     BERT V3 extends the BERT ecosystem as a separate Community Layer while
 *     preserving the existing protocol architecture and enabling communities
 *     to coordinate decisions and capital transparently on EVM-compatible
 *     blockchains.
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

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {ICommunityHub} from "../interfaces/ICommunityHub.sol";
import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";
import {CommunityTypes} from "../utils/CommunityTypes.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title CommunityHub
 * @notice Stores the governance state and enforces the rules of one BERT V3 community.
 * @dev CommunityTreasury holds USDC. This contract records membership, roles, proposal lifecycle,
 * validator participation, and calls Treasury only after the required governance checks pass.
 * 
 * @custom:version 1.0.0
 */
contract CommunityHub is ICommunityHub, ReentrancyGuard {
    /** @notice Winning member proposals required before a member may be nominated as a validator. */
    uint256 public constant VALIDATOR_PROPOSAL_POINTS_THRESHOLD = 15;
    /** @notice Maximum simultaneous local validators, limiting validation-set iteration cost. */
    uint256 public constant MAX_ACTIVE_VALIDATORS = 50;
    /** @notice Maximum proposals that one slate round may contain. */
    uint256 public constant MAX_SLATE_PROPOSALS_PER_ROUND = 30;
    /** @notice Hard protocol-wide maximum USDC stake for one binary or slate vote. */
    uint256 public constant MAX_VOTE_STAKE_USDC = 10_000 * 1e6;
    /** @notice Basis-point denominator used by fee and reward-share calculations. */
    uint256 private constant BPS_DENOMINATOR = 10_000;
    /** @notice Highest permitted binary rejection fee, equal to ten percent. */
    uint256 private constant MAX_REJECTION_FEE_BPS = 1_000;

    /** @notice Community creator recorded at deployment and required to be an initial admin. */
    address public immutable creator;
    /** @notice Paired Treasury that exclusively custody-holds this community's USDC. */
    ICommunityTreasury private immutable treasury;
    /** @notice Hash of the full immutable CommunityConfig that Factory checks during activation. */
    bytes32 public immutable override configHash;

    /** @notice USDC stake required to join the community. */
    uint256 public immutable entryStakeUSDC;
    /** @notice USDC anti-spam bond required to submit a member proposal. */
    uint256 public immutable proposalBondUSDC;
    /** @notice Minimum USDC commitment permitted for each vote. */
    uint256 public immutable voteMinStakeUSDC;
    /** @notice Community-clock delay between requesting and finalizing member exit. */
    uint256 public immutable membershipExitCooldown;
    /** @notice Number of validator approvals required for a member proposal to pass review. */
    uint256 public immutable validatorApprovalThreshold;
    /** @notice Number of local admin approvals required for a Treasury withdrawal. */
    uint256 public immutable override adminApprovalThreshold;
    /** @notice NO-side fee in basis points retained by BERT when a binary proposal is rejected. */
    uint256 public immutable binaryRejectionFeeBps;
    /** @notice Portion of successful local funding routed to active validators, in basis points. */
    uint256 public immutable override validatorRewardShareBps;
    /** @notice Duration of the validator review window measured by the community clock. */
    uint256 public immutable validationWindow;
    /** @notice Duration of an open binary voting window measured by the community clock. */
    uint256 public immutable binaryVotingDuration;
    /** @notice Duration of an open slate-round voting window measured by the community clock. */
    uint256 public immutable roundVotingDuration;
    /** @notice Duration of one validator activity and reward-accounting epoch. */
    uint256 public immutable validatorRewardEpoch;
    /** @notice Required share of available validation cases, in basis points, for epoch rewards. */
    uint256 public immutable validatorActiveThresholdBps;

    /** @notice Wall-clock timestamp at which the current pause began; zero while unpaused. */
    uint64 public pausedAt;
    /** @notice Final frozen community-clock timestamp recorded on archival; zero before archive. */
    uint64 public archivedAt;
    /** @notice Aggregate real-time seconds excluded from the community governance clock. */
    uint256 public totalPausedDuration;
    /** @notice Current lifecycle state: Active, Paused, or Archived. */
    CommunityTypes.CommunityStatus public override communityStatus;

    /** @notice Last assigned monotonic proposal identifier. */
    uint256 public proposalCount;
    /** @notice Last assigned monotonic slate-round identifier. */
    uint256 public roundCount;
    /** @notice Open binary proposals whose voting escrow has not yet settled. */
    uint256 public activeBinaryProposalCount;
    /** @notice Open slate rounds whose aggregate voting escrow has not yet settled. */
    uint256 public activeSlateRoundCount;
    /** @notice Member proposals still pending validation, voting, or slate-round settlement. */
    uint256 public unresolvedMemberProposalCount;
    /** @notice Identifier of the currently open validator activity epoch. */
    uint256 public currentValidatorRewardEpochId;
    /** @notice Number of accounts currently holding the local admin role. */
    uint256 public adminCount;
    /** @notice Number of accounts currently holding the local validator role. */
    uint256 public validatorCount;
    /** @notice Member proposals still awaiting a validator outcome. */
    uint256 public pendingValidationProposalCount;

    /** @notice Full governance record for each proposal ID. */
    mapping(uint256 => CommunityTypes.Proposal) private proposals;
    /** @notice Full state record for each slate round ID. */
    mapping(uint256 => CommunityTypes.CommunityRound) private rounds;
    /** @notice Ordered proposal IDs per slate round; order is the deterministic tie-break order. */
    mapping(uint256 => uint256[]) private proposalIdsByRound;
    /** @notice Whether a proposal ID was included in a given slate round. */
    mapping(uint256 => mapping(uint256 => bool)) private proposalIncludedInRound;
    /** @notice The one slate proposal selected by a voter in a given round. */
    mapping(uint256 => mapping(address => uint256)) private selectedProposalByRound;
    /** @notice Whether a voter has cleared their post-settlement slate vote exit lock. */
    mapping(uint256 => mapping(address => bool)) private roundVoteLockCleared;
    /** @notice Whether a validator has already cast a review decision for a member proposal. */
    mapping(uint256 => mapping(address => bool)) public validatorDecisionCast;
    /** @notice Review direction recorded for each validator decision. */
    mapping(uint256 => mapping(address => bool)) public validatorApprovedProposal;
    /** @notice Binary choice cast by each voter for each proposal. */
    mapping(uint256 => mapping(address => CommunityTypes.VoteChoice)) private voteChoiceByProposal;
    /** @notice USDC stake committed by each voter to each binary proposal. */
    mapping(uint256 => mapping(address => uint256)) private voteStakeByProposal;
    /** @notice Whether a voter has cleared their post-settlement binary vote exit lock. */
    mapping(uint256 => mapping(address => bool)) public voteLockCleared;
    /** @notice Validator reward epoch in which each member proposal was submitted for review. */
    mapping(uint256 => uint256) public validationEpochIdByProposal;

    /** @notice Activity and reward snapshot for each validator epoch. */
    mapping(uint256 => CommunityTypes.ValidatorRewardEpoch) private validatorRewardEpochs;
    /** @notice Validation cases completed by each validator during each epoch. */
    mapping(uint256 => mapping(address => uint256)) public validatorValidationCount;

    /** @notice Local admin role membership by account. */
    mapping(address => bool) private admins;
    /** @notice Local validator role membership by account. */
    mapping(address => bool) private validators;
    /** @notice Membership, exit, stake, and proposal-point state by account. */
    mapping(address => CommunityTypes.MemberInfo) private members;
    /** @notice Unresolved member proposals created by each account, used as an exit blocker. */
    mapping(address => uint256) public activeMemberProposalCount;
    /** @notice Settled vote locks not yet cleared by each account, used as an exit blocker. */
    mapping(address => uint256) public unresolvedVoteLockCount;

    /**
     * @dev Epoch settlement iterates only validators that performed validation work in that epoch.
     * This avoids an ever-growing historical validator list making finalization uncallable.
     */
    mapping(uint256 => address[]) private validatorsByRewardEpoch;
    /** @notice Prevents duplicate inclusion of a validator in one epoch's compact participant list. */
    mapping(uint256 => mapping(address => bool)) private validatorRecordedForEpoch;

    /**
     * @notice Restricts actions to a governance-active community.
     * @dev Rejects both temporary pauses and permanent archival.
     */
    modifier onlyActiveCommunity() {
        if (communityStatus == CommunityTypes.CommunityStatus.Paused) revert CommunityIsPaused();
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
        _;
    }

    /** @notice Restricts actions to an unpaused community while still allowing archival unwind paths. */
    modifier onlyUnpausedCommunity() {
        if (communityStatus == CommunityTypes.CommunityStatus.Paused) revert CommunityIsPaused();
        _;
    }

    /** @notice Restricts roster mutations to communities that have not been permanently archived. */
    modifier onlyNotArchived() {
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
        _;
    }

    /** @notice Restricts a call to an account with the local admin role. */
    modifier onlyAdmin() {
        if (!admins[msg.sender]) revert NotCommunityAdmin(msg.sender);
        _;
    }

    /** @notice Restricts a call to an account with the local validator role. */
    modifier onlyValidator() {
        if (!validators[msg.sender]) revert NotCommunityValidator(msg.sender);
        _;
    }

    /** @notice Restricts a call to an account with an active, stake-backed membership. */
    modifier onlyActiveMember() {
        if (!members[msg.sender].active) revert NotCommunityMember(msg.sender);
        _;
    }

    /**
     * @notice Restricts a call to an existing proposal ID.
     * @param proposalId Proposal identifier that must be in the range one through proposalCount.
     */
    modifier proposalExists(uint256 proposalId) {
        if (proposalId == 0 || proposalId > proposalCount) {
            revert CommunityProposalNotFound(proposalId);
        }
        _;
    }

    /**
     * @notice Creates a CommunityHub from a validated immutable configuration.
     * @param config_ Community-level settings and initial role holders.
     * @param communityTreasury_ Treasury paired with this Hub by CommunityFactory.
     * @param creator_ Address that created the community and must be an initial admin.
     */
    constructor(
        CommunityTypes.CommunityConfig memory config_,
        ICommunityTreasury communityTreasury_,
        address creator_
    ) {
        _validateConfig(config_, communityTreasury_, creator_);

        creator = creator_;
        treasury = communityTreasury_;
        configHash = keccak256(abi.encode(config_));
        entryStakeUSDC = config_.entryStakeUSDC;
        proposalBondUSDC = config_.proposalBondUSDC;
        voteMinStakeUSDC = config_.voteMinStakeUSDC;
        membershipExitCooldown = config_.membershipExitCooldown;
        validatorApprovalThreshold = config_.validatorApprovalThreshold;
        adminApprovalThreshold = config_.adminApprovalThreshold;
        binaryRejectionFeeBps = config_.binaryRejectionFeeBps;
        validatorRewardShareBps = config_.validatorRewardShareBps;
        validationWindow = config_.validationWindow;
        binaryVotingDuration = config_.binaryVotingDuration;
        roundVotingDuration = config_.roundVotingDuration;
        validatorRewardEpoch = config_.validatorRewardEpoch;
        validatorActiveThresholdBps = config_.validatorActiveThresholdBps;
        communityStatus = CommunityTypes.CommunityStatus.Active;

        for (uint256 i; i < config_.initialAdmins.length; ++i) {
            _addAdmin(config_.initialAdmins[i]);
        }
        if (!admins[creator_]) revert InvalidCommunityConfig("creator must be an initial admin");

        for (uint256 i; i < config_.initialValidators.length; ++i) {
            _addValidator(config_.initialValidators[i]);
        }

        currentValidatorRewardEpochId = 1;
        _openValidatorRewardEpoch(currentValidatorRewardEpochId, _communityTime());
    }

    /**
     * @notice Reports whether an account currently holds the local admin role.
     * @param account Address whose local role is queried.
     * @return True when the address is an active admin.
     */
    function isAdminAccount(address account) external view override returns (bool) {
        return admins[account];
    }

    /**
     * @notice Returns the Treasury paired with this Hub at construction.
     * @return Treasury contract address that custody-holds this community's USDC.
     */
    function communityTreasury() external view override returns (address) {
        return address(treasury);
    }

    /**
     * @notice Reports whether an account currently holds the local validator role.
     * @param account Address whose local role is queried.
     * @return True when the address is an active validator.
     */
    function isValidatorAccount(address account) external view returns (bool) {
        return validators[account];
    }

    /**
     * @notice Returns the community clock used for governance deadlines.
     * @dev The clock stops while paused, so validation and voting windows cannot elapse on pause.
     * @return Pause-adjusted community timestamp.
     */
    function communityTime() external view returns (uint64) {
        return _communityTime();
    }

    /**
     * @notice Returns local membership state for an account.
     * @param account Address whose membership record is queried.
     * @return Complete member record, including stake, exit state, and proposal points.
     */
    function getMember(address account)
        external
        view
        returns (CommunityTypes.MemberInfo memory)
    {
        return members[account];
    }

    /**
     * @notice Returns the complete state of one community proposal.
     * @param proposalId Existing proposal identifier.
     * @return Complete proposal record.
     */
    function getProposal(uint256 proposalId)
        external
        view
        proposalExists(proposalId)
        returns (CommunityTypes.Proposal memory)
    {
        return proposals[proposalId];
    }

    /**
     * @notice Returns the complete state of one slate round.
     * @param roundId Existing slate-round identifier.
     * @return Complete round record including settlement result.
     */
    function getRound(uint256 roundId)
        external
        view
        returns (CommunityTypes.CommunityRound memory)
    {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
        return rounds[roundId];
    }

    /**
     * @notice Returns slate proposal IDs in their stored deterministic tie-break order.
     * @param roundId Existing slate-round identifier.
     * @return Ordered proposal identifiers included in the round.
     */
    function getRoundProposalIds(uint256 roundId) external view returns (uint256[] memory) {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
        return proposalIdsByRound[roundId];
    }

    /**
     * @notice Returns the vote direction and USDC commitment recorded for one binary voter.
     * @param proposalId Existing binary proposal identifier.
     * @param voter Voter address to inspect.
     * @return choice Recorded vote direction, or None when no vote exists.
     * @return stake USDC stake recorded for the vote.
     */
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        override
        proposalExists(proposalId)
        returns (CommunityTypes.VoteChoice choice, uint256 stake)
    {
        return (voteChoiceByProposal[proposalId][voter], voteStakeByProposal[proposalId][voter]);
    }

    /** @notice Pauses new governance actions and freezes the community clock. */
    function pauseCommunity() external onlyAdmin onlyActiveCommunity {
        pausedAt = uint64(block.timestamp);
        communityStatus = CommunityTypes.CommunityStatus.Paused;
        emit CommunityStatusChanged(communityStatus);
    }

    /** @notice Resumes governance and excludes the paused real-time duration from all deadlines. */
    function unpauseCommunity() external onlyAdmin {
        if (communityStatus != CommunityTypes.CommunityStatus.Paused) revert CommunityNotActive();

        totalPausedDuration += block.timestamp - pausedAt;
        pausedAt = 0;
        communityStatus = CommunityTypes.CommunityStatus.Active;
        emit CommunityStatusChanged(communityStatus);
    }

    /**
     * @notice Permanently closes governance after every fund-bearing proposal and round is resolved.
     * @dev Archival blocks new governance and withdrawals, while allowing exits, refunds, and accrued rewards.
     */
    function archiveCommunity() external onlyAdmin {
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
        if (
            pendingValidationProposalCount != 0 ||
            activeBinaryProposalCount != 0 ||
            activeSlateRoundCount != 0 ||
            unresolvedMemberProposalCount != 0
        ) {
            revert CommunityArchiveBlocked(
                pendingValidationProposalCount,
                activeBinaryProposalCount,
                activeSlateRoundCount,
                unresolvedMemberProposalCount
            );
        }

        archivedAt = _communityTime();
        pausedAt = 0;
        communityStatus = CommunityTypes.CommunityStatus.Archived;
        emit CommunityStatusChanged(communityStatus);
        emit CommunityArchived(archivedAt);
    }

    /**
     * @notice Grants the local admin role to an address that is not a validator.
     * @param account Address to receive the admin role.
     */
    function addAdmin(address account) external onlyAdmin onlyNotArchived {
        _addAdmin(account);
    }

    /**
     * @notice Removes a local admin while preserving at least one active admin.
     * @param account Admin address to remove.
     */
    function removeAdmin(address account) external onlyAdmin onlyNotArchived {
        _removeAdmin(account);
    }

    /**
     * @notice Atomically grants another address admin status and removes the caller's admin role.
     * @param newAdmin Address receiving the caller's local admin position.
     */
    function transferAdminRole(address newAdmin) external onlyAdmin onlyNotArchived {
        _addAdmin(newAdmin);
        _removeAdmin(msg.sender);
    }

    /**
     * @notice Lets an admin drop their local role after archival so a membership stake can be released.
     * @dev The final admin may renounce because archived communities no longer permit governance actions.
     */
    function renounceAdminRole() external onlyAdmin {
        if (communityStatus != CommunityTypes.CommunityStatus.Archived) revert CommunityNotActive();

        admins[msg.sender] = false;
        adminCount -= 1;
        emit AdminRemoved(msg.sender);
    }

    /**
     * @notice Appoints an eligible active member to the local validator set.
     * @dev Constructor-supplied initial validators are the bootstrap exception; all later appointments
     * require local proposal-point eligibility and remain incompatible with the admin role.
     * @param account Eligible member to appoint.
     */
    function addValidator(address account) external onlyAdmin onlyNotArchived {
        _requireValidatorSetUnlocked();
        if (admins[account]) revert AdminValidatorRoleConflict(account);
        _requireValidatorEligibility(account);
        _addValidator(account);
    }

    /**
     * @notice Removes a validator when no proposal is awaiting validator review.
     * @param account Validator address to remove.
     */
    function removeValidator(address account) external onlyAdmin onlyNotArchived {
        _requireValidatorSetUnlocked();
        _removeValidator(account);
    }

    /** @notice Lets a validator resign when no proposal is awaiting validator review. */
    function renounceValidatorRole() external onlyValidator {
        _requireValidatorSetUnlocked();
        _removeValidator(msg.sender);
    }

    /**
     * @notice Reports whether an active member may be nominated as a local validator.
     * @dev Eligibility is a qualification only; a community admin must still call addValidator.
     * @param account Address to inspect.
     */
    function isValidatorEligible(address account) external view returns (bool) {
        return
            members[account].active &&
            members[account].proposalPoints >= VALIDATOR_PROPOSAL_POINTS_THRESHOLD;
    }

    /**
     * @notice Pulls the configured entry stake into Treasury and activates the caller's membership.
     * @dev Caller must approve Treasury for entryStakeUSDC before calling.
     */
    function joinCommunity() external onlyActiveCommunity nonReentrant {
        CommunityTypes.MemberInfo storage member = members[msg.sender];
        if (member.active) revert AlreadyCommunityMember(msg.sender);

        treasury.depositMembershipStake(msg.sender, entryStakeUSDC);

        member.active = true;
        member.joinedAt = _communityTime();
        member.exitRequestedAt = 0;
        member.membershipStake = entryStakeUSDC;
        emit MemberJoined(msg.sender, entryStakeUSDC);
    }

    /**
     * @notice Starts the membership exit cooldown without releasing stake yet.
     * @dev Archived communities waive the delay at finalization, but the request remains explicit.
     */
    function requestMembershipExit() external onlyUnpausedCommunity onlyActiveMember {
        CommunityTypes.MemberInfo storage member = members[msg.sender];
        if (member.exitRequestedAt != 0) revert ExitAlreadyRequested(msg.sender);

        member.exitRequestedAt = _communityTime();
        uint256 availableAt = communityStatus == CommunityTypes.CommunityStatus.Archived
            ? member.exitRequestedAt
            : uint256(member.exitRequestedAt) + membershipExitCooldown;
        emit MembershipExitRequested(msg.sender, availableAt);
    }

    /**
     * @notice Releases membership stake after cooldown and after every governance exit blocker clears.
     * @dev Admins, validators, proposal authors, and voters with uncleared locks cannot exit.
     */
    function finalizeMembershipExit()
        external
        onlyUnpausedCommunity
        onlyActiveMember
        nonReentrant
    {
        CommunityTypes.MemberInfo storage member = members[msg.sender];
        if (member.exitRequestedAt == 0) revert ExitNotRequested(msg.sender);

        uint256 availableAt = uint256(member.exitRequestedAt) + membershipExitCooldown;
        if (
            communityStatus != CommunityTypes.CommunityStatus.Archived &&
            _communityTime() < availableAt
        ) revert ExitCooldownNotFinished(availableAt);
        if (
            admins[msg.sender] ||
            validators[msg.sender] ||
            activeMemberProposalCount[msg.sender] != 0 ||
            unresolvedVoteLockCount[msg.sender] != 0
        ) {
            revert MembershipExitBlocked(msg.sender);
        }

        uint256 stake = member.membershipStake;
        member.active = false;
        member.joinedAt = 0;
        member.exitRequestedAt = 0;
        member.membershipStake = 0;

        treasury.releaseMembershipStake(msg.sender, stake);
        emit MembershipExited(msg.sender, stake);
    }

    /**
     * @notice Creates an admin-owned binary YES/NO proposal ready to open for voting.
     * @param title Short proposal title.
     * @param description Proposal body or summary.
     * @param metadataURI Offchain metadata URI.
     * @return proposalId Newly assigned proposal identifier.
     */
    function createAdminProposal(
        string calldata title,
        string calldata description,
        string calldata metadataURI
    ) external onlyAdmin onlyActiveCommunity returns (uint256 proposalId) {
        _requireProposalText(title, description);

        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = msg.sender;
        proposal.origin = CommunityTypes.ProposalOrigin.Admin;
        proposal.mode = CommunityTypes.ProposalMode.Binary;
        proposal.status = CommunityTypes.ProposalStatus.ApprovedForVoting;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = _communityTime();

        emit ProposalCreated(proposalId, msg.sender, CommunityTypes.ProposalOrigin.Admin);
    }

    /**
     * @notice Creates a member-owned binary proposal, starts validator review, and locks its bond.
     * @param title Short proposal title.
     * @param description Proposal body or summary.
     * @param metadataURI Offchain metadata URI.
     * @return proposalId Newly assigned proposal identifier.
     */
    function createMemberProposal(
        string calldata title,
        string calldata description,
        string calldata metadataURI
    ) external onlyActiveMember onlyActiveCommunity nonReentrant returns (uint256 proposalId) {
        _requireNoPendingExit(msg.sender);
        _requireProposalText(title, description);
        _rollValidatorRewardEpoch();

        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = msg.sender;
        proposal.origin = CommunityTypes.ProposalOrigin.Member;
        proposal.mode = CommunityTypes.ProposalMode.Binary;
        proposal.status = CommunityTypes.ProposalStatus.PendingValidation;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = _communityTime();
        proposal.validationDeadline = _communityTime() + uint64(validationWindow);
        proposal.bondAmount = proposalBondUSDC;

        validationEpochIdByProposal[proposalId] = currentValidatorRewardEpochId;
        validatorRewardEpochs[currentValidatorRewardEpochId].availableValidationCases += 1;
        activeMemberProposalCount[msg.sender] += 1;
        unresolvedMemberProposalCount += 1;
        pendingValidationProposalCount += 1;

        treasury.depositProposalBond(proposalId, msg.sender, proposalBondUSDC);
        emit ProposalCreated(proposalId, msg.sender, CommunityTypes.ProposalOrigin.Member);
    }

    /**
     * @notice Creates an admin-owned proposal eligible for an admin slate round.
     * @param title Short proposal title.
     * @param description Proposal body or summary.
     * @param metadataURI Offchain metadata URI.
     * @return proposalId Newly created proposal identifier.
     */
    function createAdminSlateProposal(
        string calldata title,
        string calldata description,
        string calldata metadataURI
    ) external onlyAdmin onlyActiveCommunity returns (uint256 proposalId) {
        _requireProposalText(title, description);
        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = msg.sender;
        proposal.origin = CommunityTypes.ProposalOrigin.Admin;
        proposal.mode = CommunityTypes.ProposalMode.Slate;
        proposal.status = CommunityTypes.ProposalStatus.ApprovedForRound;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = _communityTime();
        emit ProposalCreated(proposalId, msg.sender, CommunityTypes.ProposalOrigin.Admin);
    }

    /**
     * @notice Creates a member-owned slate proposal and locks its anti-spam bond.
     * @dev Validators must approve it before an admin can include it in a member slate round.
     * @param title Short proposal title.
     * @param description Proposal body or summary.
     * @param metadataURI Offchain metadata URI.
     * @return proposalId Newly created proposal identifier.
     */
    function createMemberSlateProposal(
        string calldata title,
        string calldata description,
        string calldata metadataURI
    ) external onlyActiveMember onlyActiveCommunity nonReentrant returns (uint256 proposalId) {
        _requireNoPendingExit(msg.sender);
        _requireProposalText(title, description);
        _rollValidatorRewardEpoch();
        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = msg.sender;
        proposal.origin = CommunityTypes.ProposalOrigin.Member;
        proposal.mode = CommunityTypes.ProposalMode.Slate;
        proposal.status = CommunityTypes.ProposalStatus.PendingValidation;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = _communityTime();
        proposal.validationDeadline = _communityTime() + uint64(validationWindow);
        proposal.bondAmount = proposalBondUSDC;
        validationEpochIdByProposal[proposalId] = currentValidatorRewardEpochId;
        validatorRewardEpochs[currentValidatorRewardEpochId].availableValidationCases += 1;
        activeMemberProposalCount[msg.sender] += 1;
        unresolvedMemberProposalCount += 1;
        pendingValidationProposalCount += 1;
        treasury.depositProposalBond(proposalId, msg.sender, proposalBondUSDC);
        emit ProposalCreated(proposalId, msg.sender, CommunityTypes.ProposalOrigin.Member);
    }

    /**
     * @notice Records one validator's approval or rejection of a pending member proposal.
     * @dev Automatically finalizes once approval succeeds or becomes mathematically impossible.
     * @param proposalId Pending member proposal under review.
     * @param approved True to approve the proposal, false to reject it.
     */
    function castValidationDecision(uint256 proposalId, bool approved)
        external
        onlyValidator
        onlyActiveCommunity
        proposalExists(proposalId)
        nonReentrant
    {
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        if (proposal.status != CommunityTypes.ProposalStatus.PendingValidation) {
            revert InvalidProposalState(proposalId);
        }
        if (_communityTime() >= proposal.validationDeadline) revert ValidationWindowClosed(proposalId);
        if (validatorDecisionCast[proposalId][msg.sender]) {
            revert ValidatorDecisionAlreadyCast(proposalId, msg.sender);
        }

        validatorDecisionCast[proposalId][msg.sender] = true;
        validatorApprovedProposal[proposalId][msg.sender] = approved;
        uint256 epochId = validationEpochIdByProposal[proposalId];
        validatorValidationCount[epochId][msg.sender] += 1;
        if (!validatorRecordedForEpoch[epochId][msg.sender]) {
            validatorRecordedForEpoch[epochId][msg.sender] = true;
            validatorsByRewardEpoch[epochId].push(msg.sender);
        }

        if (approved) {
            proposal.approvalCount += 1;
        } else {
            proposal.rejectionCount += 1;
        }
        emit ValidatorDecisionCast(proposalId, msg.sender, approved);

        if (proposal.approvalCount >= validatorApprovalThreshold) {
            _finalizeMemberProposalValidation(proposalId, true);
            return;
        }

        uint256 remainingValidators = validatorCount - proposal.approvalCount - proposal.rejectionCount;
        if (proposal.approvalCount + remainingValidators < validatorApprovalThreshold) {
            _finalizeMemberProposalValidation(proposalId, false);
        }
    }

    /**
     * @notice Finalizes an expired member proposal review using the approvals received by deadline.
     * @param proposalId Pending member proposal whose validation window has expired.
     */
    function finalizeMemberProposalValidation(uint256 proposalId)
        external
        onlyActiveCommunity
        proposalExists(proposalId)
        nonReentrant
    {
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        if (proposal.status != CommunityTypes.ProposalStatus.PendingValidation) {
            revert InvalidProposalState(proposalId);
        }
        if (_communityTime() < proposal.validationDeadline) {
            revert ValidationStillOpen(proposalId, proposal.validationDeadline);
        }

        _finalizeMemberProposalValidation(
            proposalId,
            proposal.approvalCount >= validatorApprovalThreshold
        );
    }

    /**
     * @notice Opens the configured binary voting window for an approved proposal.
     * @param proposalId Admin proposal or validator-approved member proposal to open.
     */
    function openBinaryVoting(uint256 proposalId)
        external
        onlyAdmin
        onlyActiveCommunity
        proposalExists(proposalId)
    {
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        if (
            proposal.mode != CommunityTypes.ProposalMode.Binary ||
            proposal.status != CommunityTypes.ProposalStatus.ApprovedForVoting
        ) {
            revert InvalidProposalState(proposalId);
        }

        uint64 timestamp = _communityTime();
        proposal.status = CommunityTypes.ProposalStatus.InVoting;
        proposal.votingStartedAt = timestamp;
        proposal.votingDeadline = timestamp + uint64(binaryVotingDuration);
        activeBinaryProposalCount += 1;
        emit BinaryVotingOpened(proposalId, proposal.votingDeadline);
    }

    /**
     * @notice Commits a member's USDC stake to one YES or NO choice in an open binary vote.
     * @param proposalId Open binary proposal identifier.
     * @param choice YES or NO vote direction; None is invalid.
     * @param amount USDC stake in token-native units, bounded by configured minimum and hard cap.
     */
    function castBinaryVote(
        uint256 proposalId,
        CommunityTypes.VoteChoice choice,
        uint256 amount
    )
        external
        onlyActiveMember
        onlyActiveCommunity
        proposalExists(proposalId)
        nonReentrant
    {
        _requireNoPendingExit(msg.sender);
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        if (
            proposal.mode != CommunityTypes.ProposalMode.Binary ||
            proposal.status != CommunityTypes.ProposalStatus.InVoting
        ) revert VotingNotOpen(proposalId);
        if (_communityTime() >= proposal.votingDeadline) revert VotingWindowClosed(proposalId);
        if (choice == CommunityTypes.VoteChoice.None) revert InvalidVoteChoice();
        if (voteChoiceByProposal[proposalId][msg.sender] != CommunityTypes.VoteChoice.None) {
            revert BinaryVoteAlreadyCast(proposalId, msg.sender);
        }
        if (amount < voteMinStakeUSDC) revert VoteStakeTooLow(amount, voteMinStakeUSDC);
        if (amount > MAX_VOTE_STAKE_USDC) {
            revert VoteAmountCapExceeded(amount, MAX_VOTE_STAKE_USDC);
        }

        treasury.depositVoteStake(proposalId, msg.sender, amount);
        voteChoiceByProposal[proposalId][msg.sender] = choice;
        voteStakeByProposal[proposalId][msg.sender] = amount;
        unresolvedVoteLockCount[msg.sender] += 1;

        if (choice == CommunityTypes.VoteChoice.Yes) {
            proposal.yesVotes += amount;
        } else {
            proposal.noVotes += amount;
        }
        emit BinaryVoteCast(proposalId, msg.sender, choice, amount);
    }

    /**
     * @notice Settles an ended binary proposal and executes its Treasury accounting flow.
     * @dev YES must strictly exceed NO; a tie follows the NO/refund route.
     * @param proposalId Ended binary proposal identifier.
     */
    function settleBinaryProposal(uint256 proposalId)
        external
        onlyActiveCommunity
        proposalExists(proposalId)
        nonReentrant
    {
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        if (
            proposal.mode != CommunityTypes.ProposalMode.Binary ||
            proposal.status != CommunityTypes.ProposalStatus.InVoting
        ) {
            revert InvalidProposalState(proposalId);
        }
        if (_communityTime() < proposal.votingDeadline) {
            revert VotingStillOpen(proposalId, proposal.votingDeadline);
        }

        bool accepted = proposal.yesVotes > proposal.noVotes;
        if (accepted) {
            _rollValidatorRewardEpoch();
            treasury.settleBinaryYesWin(
                proposalId,
                proposal.yesVotes,
                proposal.noVotes,
                currentValidatorRewardEpochId
            );
        } else {
            treasury.settleBinaryNoWin(
                proposalId,
                proposal.yesVotes,
                proposal.noVotes,
                binaryRejectionFeeBps
            );
        }

        proposal.accepted = accepted;
        proposal.settled = true;
        proposal.status = CommunityTypes.ProposalStatus.Settled;
        activeBinaryProposalCount -= 1;

        if (proposal.origin == CommunityTypes.ProposalOrigin.Member) {
            treasury.returnProposalBond(proposalId, proposal.creator);
            activeMemberProposalCount[proposal.creator] -= 1;
            unresolvedMemberProposalCount -= 1;

            if (accepted) {
                _awardProposalPoint(proposalId, proposal.creator);
            }
        }
        emit BinaryProposalSettled(proposalId, accepted);
    }

    /**
     * @notice Opens a slate round containing only approved admin slate proposals.
     * @param proposalIds Ordered proposal IDs used for the deterministic tie-break rule.
     * @return roundId Newly created round identifier.
     */
    function createAdminSlateRound(uint256[] calldata proposalIds)
        external
        onlyAdmin
        onlyActiveCommunity
        returns (uint256 roundId)
    {
        return _createSlateRound(CommunityTypes.ProposalOrigin.Admin, proposalIds);
    }

    /**
     * @notice Opens a slate round containing only validator-approved member slate proposals.
     * @param proposalIds Ordered proposal IDs used for the deterministic tie-break rule.
     * @return roundId Newly created round identifier.
     */
    function createMemberSlateRound(uint256[] calldata proposalIds)
        external
        onlyAdmin
        onlyActiveCommunity
        returns (uint256 roundId)
    {
        return _createSlateRound(CommunityTypes.ProposalOrigin.Member, proposalIds);
    }

    /**
     * @notice Commits one member's USDC stake to exactly one proposal in an open slate round.
     * @dev The stake is non-refundable and the full round escrow is routed to local community buckets
     * when the round settles. A member cannot vote while their membership exit is pending.
     * @param roundId Slate round identifier.
     * @param proposalId Included slate proposal selected by the voter.
     * @param amount USDC stake in token-native units.
     */
    function castSlateRoundVote(uint256 roundId, uint256 proposalId, uint256 amount)
        external
        onlyActiveMember
        onlyActiveCommunity
        nonReentrant
    {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        if (round.settled || _communityTime() >= round.endTime) revert VotingWindowClosed(roundId);
        if (!proposalIncludedInRound[roundId][proposalId]) revert InvalidRoundProposal(proposalId);
        if (selectedProposalByRound[roundId][msg.sender] != 0) {
            revert RoundVoteAlreadyCast(roundId, msg.sender);
        }
        _requireNoPendingExit(msg.sender);
        if (amount < voteMinStakeUSDC) revert VoteStakeTooLow(amount, voteMinStakeUSDC);
        if (amount > MAX_VOTE_STAKE_USDC) revert VoteAmountCapExceeded(amount, MAX_VOTE_STAKE_USDC);

        treasury.depositRoundVoteStake(roundId, msg.sender, amount);
        selectedProposalByRound[roundId][msg.sender] = proposalId;
        round.totalVotes += amount;
        proposals[proposalId].roundVotes += amount;
        unresolvedVoteLockCount[msg.sender] += 1;

        emit SlateRoundVoteCast(roundId, proposalId, msg.sender, amount);
    }

    /**
     * @notice Settles a completed slate round and routes every committed vote locally.
     * @dev A strict-greater comparison preserves the earliest proposal in round order on a tie.
     * @param roundId Slate round identifier.
     */
    function settleSlateRound(uint256 roundId) external onlyActiveCommunity nonReentrant {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        if (round.settled) revert ProposalAlreadySettled(roundId);
        if (_communityTime() < round.endTime) revert VotingStillOpen(roundId, round.endTime);

        uint256[] storage proposalIds = proposalIdsByRound[roundId];
        uint256 winningProposalId = proposalIds[0];
        uint256 winningVotes = proposals[winningProposalId].roundVotes;
        for (uint256 i = 1; i < proposalIds.length; ++i) {
            uint256 candidateId = proposalIds[i];
            uint256 candidateVotes = proposals[candidateId].roundVotes;
            if (candidateVotes > winningVotes) {
                winningProposalId = candidateId;
                winningVotes = candidateVotes;
            }
        }

        _rollValidatorRewardEpoch();
        treasury.settleSlateRound(roundId, round.totalVotes, currentValidatorRewardEpochId);
        round.winningProposalId = winningProposalId;
        round.winningVotes = winningVotes;
        round.settled = true;
        activeSlateRoundCount -= 1;

        for (uint256 i; i < proposalIds.length; ++i) {
            CommunityTypes.Proposal storage proposal = proposals[proposalIds[i]];
            bool won = proposalIds[i] == winningProposalId;
            proposal.status = won
                ? CommunityTypes.ProposalStatus.WonRound
                : CommunityTypes.ProposalStatus.LostRound;
            proposal.settled = true;

            if (proposal.origin == CommunityTypes.ProposalOrigin.Member) {
                treasury.returnProposalBond(proposalIds[i], proposal.creator);
                activeMemberProposalCount[proposal.creator] -= 1;
                unresolvedMemberProposalCount -= 1;
                if (won) {
                    _awardProposalPoint(proposalIds[i], proposal.creator);
                }
            }
        }

        emit SlateRoundSettled(roundId, winningProposalId, winningVotes, round.totalVotes);
    }

    /**
     * @notice Clears the caller's slate-round vote lock after the round settles.
     * @param roundId Settled slate round identifier.
     */
    function clearSettledRoundVoteLock(uint256 roundId) external {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
        if (!rounds[roundId].settled) revert ProposalNotSettled(roundId);
        if (selectedProposalByRound[roundId][msg.sender] == 0) {
            revert VoteLockNotFound(roundId, msg.sender);
        }
        if (roundVoteLockCleared[roundId][msg.sender]) {
            revert VoteLockAlreadyCleared(roundId, msg.sender);
        }

        roundVoteLockCleared[roundId][msg.sender] = true;
        unresolvedVoteLockCount[msg.sender] -= 1;
    }

    /**
     * @notice Clears the caller's exit lock created by a settled binary vote.
     * @param proposalId Settled binary proposal on which the caller voted.
     */
    function clearSettledVoteLock(uint256 proposalId)
        external
        proposalExists(proposalId)
    {
        if (!proposals[proposalId].settled) revert ProposalNotSettled(proposalId);
        if (voteChoiceByProposal[proposalId][msg.sender] == CommunityTypes.VoteChoice.None) {
            revert VoteLockNotFound(proposalId, msg.sender);
        }
        if (voteLockCleared[proposalId][msg.sender]) {
            revert VoteLockAlreadyCleared(proposalId, msg.sender);
        }

        voteLockCleared[proposalId][msg.sender] = true;
        unresolvedVoteLockCount[msg.sender] -= 1;
    }

    /**
     * @notice Returns validator activity and reward accounting for an existing epoch.
     * @param epochId Validator epoch identifier.
     * @return Complete epoch record.
     */
    function getValidatorRewardEpoch(uint256 epochId)
        external
        view
        returns (CommunityTypes.ValidatorRewardEpoch memory)
    {
        CommunityTypes.ValidatorRewardEpoch memory epoch = validatorRewardEpochs[epochId];
        if (epoch.startTime == 0) revert ValidatorRewardEpochNotFound(epochId);
        return epoch;
    }

    /**
     * @notice Reports whether a validator completed enough available cases to receive an epoch reward.
     * @param epochId Finalized validator reward epoch.
     * @param validator Validator account to inspect.
     * @return True when the validator meets the configured participation threshold.
     */
    function isValidatorActiveForEpoch(uint256 epochId, address validator)
        external
        view
        override
        returns (bool)
    {
        CommunityTypes.ValidatorRewardEpoch storage epoch = validatorRewardEpochs[epochId];
        if (!epoch.finalized || epoch.availableValidationCases == 0) return false;

        return validatorValidationCount[epochId][validator] >= _requiredValidationCases(epoch.availableValidationCases);
    }

    /**
     * @notice Finalizes a completed validator epoch and makes equal rewards claimable in Treasury.
     * @param epochId Expired validator reward epoch to finalize.
     */
    function finalizeValidatorRewardEpoch(uint256 epochId)
        external
        onlyActiveCommunity
        nonReentrant
    {
        CommunityTypes.ValidatorRewardEpoch storage epoch = validatorRewardEpochs[epochId];
        if (epoch.startTime == 0) revert ValidatorRewardEpochNotFound(epochId);
        if (epoch.finalized) revert ValidatorRewardEpochAlreadyFinalized(epochId);

        uint256 availableAt = uint256(epoch.endTime) + validationWindow;
        if (_communityTime() < availableAt) revert ValidationStillOpen(epochId, availableAt);

        uint256 activeValidatorCount;
        if (epoch.availableValidationCases != 0) {
            uint256 requiredCases = _requiredValidationCases(epoch.availableValidationCases);
            address[] storage epochValidators = validatorsByRewardEpoch[epochId];
            for (uint256 i; i < epochValidators.length; ++i) {
                if (validatorValidationCount[epochId][epochValidators[i]] >= requiredCases) {
                    activeValidatorCount += 1;
                }
            }
        }

        epoch.activeValidatorCount = activeValidatorCount;
        epoch.finalized = true;
        treasury.finalizeValidatorRewardEpoch(epochId, activeValidatorCount);
        emit ValidatorRewardEpochFinalized(epochId, activeValidatorCount);
    }

    /** @notice Opens a new validator epoch when the current epoch has expired. */
    function rollValidatorRewardEpoch() external onlyActiveCommunity {
        _rollValidatorRewardEpoch();
    }

    /**
     * @notice Calculates the pause-adjusted community timestamp used by all governance deadlines.
     * @return Current community-clock timestamp, frozen while paused and after archival.
     */
    function _communityTime() internal view returns (uint64) {
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) {
            return archivedAt;
        }
        if (communityStatus == CommunityTypes.CommunityStatus.Paused) {
            return uint64(uint256(pausedAt) - totalPausedDuration);
        }
        return uint64(block.timestamp - totalPausedDuration);
    }

    /**
     * @notice Validates immutable deployment configuration before any community state is initialized.
     * @param config_ Proposed immutable community configuration.
     * @param communityTreasury_ Paired Treasury expected to custody all community USDC.
     * @param creator_ Creator that must appear in the initial admin set.
     */
    function _validateConfig(
        CommunityTypes.CommunityConfig memory config_,
        ICommunityTreasury communityTreasury_,
        address creator_
    ) private pure {
        if (address(communityTreasury_) == address(0)) revert ZeroAddress("communityTreasury");
        if (creator_ == address(0)) revert ZeroAddress("creator");
        if (config_.usdc == address(0)) revert ZeroAddress("usdc");
        if (config_.globalBertReserve == address(0)) revert ZeroAddress("globalBertReserve");
        if (config_.initialAdmins.length == 0) revert InvalidCommunityConfig("initial admins");
        if (config_.initialValidators.length == 0) revert InvalidCommunityConfig("initial validators");
        if (config_.initialValidators.length > MAX_ACTIVE_VALIDATORS) {
            revert InvalidCommunityConfig("too many initial validators");
        }
        if (
            config_.entryStakeUSDC == 0 ||
            config_.proposalBondUSDC == 0 ||
            config_.voteMinStakeUSDC == 0 ||
            config_.voteMinStakeUSDC > MAX_VOTE_STAKE_USDC
        ) {
            revert InvalidCommunityConfig("USDC amounts");
        }
        if (
            config_.membershipExitCooldown == 0 ||
            config_.validationWindow == 0 ||
            config_.binaryVotingDuration == 0 ||
            config_.roundVotingDuration == 0 ||
            config_.validatorRewardEpoch == 0
        ) {
            revert InvalidCommunityConfig("durations");
        }
        if (config_.adminApprovalThreshold == 0 || config_.adminApprovalThreshold > config_.initialAdmins.length) {
            revert InvalidCommunityConfig("admin approval threshold");
        }
        if (
            config_.validatorApprovalThreshold == 0 ||
            config_.validatorApprovalThreshold > config_.initialValidators.length
        ) {
            revert InvalidCommunityConfig("validator approval threshold");
        }
        if (config_.binaryRejectionFeeBps > MAX_REJECTION_FEE_BPS) {
            revert RejectionFeeTooHigh(config_.binaryRejectionFeeBps, MAX_REJECTION_FEE_BPS);
        }
        if (
            config_.validatorRewardShareBps > BPS_DENOMINATOR ||
            config_.validatorActiveThresholdBps == 0 ||
            config_.validatorActiveThresholdBps > BPS_DENOMINATOR
        ) {
            revert InvalidCommunityConfig("basis points");
        }
    }

    /**
     * @notice Adds a local admin while enforcing admin-validator separation.
     * @param account Address to add as an admin.
     */
    function _addAdmin(address account) private {
        if (account == address(0)) revert ZeroAddress("admin");
        if (admins[account]) revert RoleAlreadyAssigned(account);
        if (validators[account]) revert AdminValidatorRoleConflict(account);

        admins[account] = true;
        adminCount += 1;
        emit AdminAdded(account);
    }

    /**
     * @notice Removes a local admin while preserving the minimum one-admin invariant.
     * @param account Existing admin address to remove.
     */
    function _removeAdmin(address account) private {
        if (!admins[account]) revert RoleNotAssigned(account);
        if (adminCount == 1) revert CannotRemoveLastAdmin();

        admins[account] = false;
        adminCount -= 1;
        emit AdminRemoved(account);
    }

    /**
     * @notice Adds a local validator while enforcing role separation and the validator-set cap.
     * @param account Address to add as a validator.
     */
    function _addValidator(address account) private {
        if (account == address(0)) revert ZeroAddress("validator");
        if (validators[account]) revert RoleAlreadyAssigned(account);
        if (admins[account]) revert AdminValidatorRoleConflict(account);
        if (validatorCount == MAX_ACTIVE_VALIDATORS) {
            revert InvalidCommunityConfig("max active validators");
        }

        validators[account] = true;
        validatorCount += 1;
        emit ValidatorAdded(account);
    }

    /**
     * @notice Removes a local validator from the active validation set.
     * @param account Existing validator address to remove.
     */
    function _removeValidator(address account) private {
        if (!validators[account]) revert RoleNotAssigned(account);

        validators[account] = false;
        validatorCount -= 1;
        emit ValidatorRemoved(account);
    }

    /**
     * @notice Finalizes a member proposal review, returning or slashing its bond as appropriate.
     * @param proposalId Pending member proposal identifier.
     * @param approved Whether validator review approved the proposal.
     */
    function _finalizeMemberProposalValidation(uint256 proposalId, bool approved) private {
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        pendingValidationProposalCount -= 1;

        if (approved) {
            proposal.status = proposal.mode == CommunityTypes.ProposalMode.Binary
                ? CommunityTypes.ProposalStatus.ApprovedForVoting
                : CommunityTypes.ProposalStatus.ApprovedForRound;
        } else {
            proposal.status = CommunityTypes.ProposalStatus.RejectedByValidators;
            activeMemberProposalCount[proposal.creator] -= 1;
            unresolvedMemberProposalCount -= 1;
            treasury.slashProposalBond(proposalId);
        }
        emit ProposalValidationFinalized(proposalId, approved);
    }

    /** @notice Opens the next validator epoch if the active epoch has expired. */
    function _rollValidatorRewardEpoch() private {
        CommunityTypes.ValidatorRewardEpoch storage currentEpoch =
            validatorRewardEpochs[currentValidatorRewardEpochId];
        if (_communityTime() < currentEpoch.endTime) return;

        currentValidatorRewardEpochId += 1;
        _openValidatorRewardEpoch(currentValidatorRewardEpochId, _communityTime());
    }

    /**
     * @notice Creates an empty validator activity epoch with the configured duration.
     * @param epochId New monotonic validator epoch identifier.
     * @param startTime Community-clock timestamp at which the epoch begins.
     */
    function _openValidatorRewardEpoch(uint256 epochId, uint64 startTime) private {
        uint64 endTime = startTime + uint64(validatorRewardEpoch);
        validatorRewardEpochs[epochId] = CommunityTypes.ValidatorRewardEpoch({
            startTime: startTime,
            endTime: endTime,
            availableValidationCases: 0,
            rewardAmount: 0,
            activeValidatorCount: 0,
            finalized: false
        });
        emit ValidatorRewardEpochRolled(epochId, startTime, endTime);
    }

    /**
     * @notice Calculates the minimum number of completed cases needed for validator reward eligibility.
     * @dev Rounds up so a nonzero participation threshold cannot be bypassed with fractional cases.
     * @param availableCases Total review cases offered in the epoch.
     * @return Required number of completed cases.
     */
    function _requiredValidationCases(uint256 availableCases) private view returns (uint256) {
        return (availableCases * validatorActiveThresholdBps + BPS_DENOMINATOR - 1) / BPS_DENOMINATOR;
    }

    /** @notice Reverts while pending proposals make validator-set changes unsafe. */
    function _requireValidatorSetUnlocked() private view {
        if (pendingValidationProposalCount != 0) revert ValidatorSetLocked();
    }

    /**
     * @notice Reverts if a member already requested exit and therefore cannot start new obligations.
     * @param member Member account to inspect.
     */
    function _requireNoPendingExit(address member) private view {
        if (members[member].exitRequestedAt != 0) revert MembershipExitBlocked(member);
    }

    /**
     * @notice Reverts unless an active member has earned the local validator nomination threshold.
     * @param account Member considered for validator appointment.
     */
    function _requireValidatorEligibility(address account) private view {
        CommunityTypes.MemberInfo storage member = members[account];
        if (!member.active || member.proposalPoints < VALIDATOR_PROPOSAL_POINTS_THRESHOLD) {
            revert ValidatorNotEligible(
                account,
                member.proposalPoints,
                VALIDATOR_PROPOSAL_POINTS_THRESHOLD
            );
        }
    }

    /**
     * @notice Awards one local member-proposal point and records threshold attainment.
     * @param proposalId Settled winning member proposal.
     * @param member Winning proposal author.
     */
    function _awardProposalPoint(uint256 proposalId, address member) private {
        CommunityTypes.MemberInfo storage memberInfo = members[member];
        memberInfo.proposalPoints += 1;
        emit ProposalPointAwarded(proposalId, member, memberInfo.proposalPoints);
        if (memberInfo.proposalPoints == VALIDATOR_PROPOSAL_POINTS_THRESHOLD) {
            emit ValidatorEligibilityReached(member, memberInfo.proposalPoints);
        }
    }

    /**
     * @notice Reverts unless a proposal supplies nonempty title and description fields.
     * @param title Proposal title to validate.
     * @param description Proposal description to validate.
     */
    function _requireProposalText(string calldata title, string calldata description) private pure {
        if (bytes(title).length == 0) revert ZeroLength("title");
        if (bytes(description).length == 0) revert ZeroLength("description");
    }

    /**
     * @notice Creates a homogeneous, immediately open slate round from approved proposals.
     * @dev Proposal IDs are retained in caller-provided order, which intentionally defines the
     * deterministic first-max tie-break rule used during settlement.
     * @param origin Proposal lane that all included proposals must belong to.
     * @param proposalIds Ordered slate proposals to include.
     * @return roundId Newly created round identifier.
     */
    /**
     * @notice Creates an immediately open slate round from homogeneous approved proposals.
     * @dev Caller order is stored and later used as the first-max deterministic tie-break order.
     * @param origin Required proposal origin for every supplied proposal ID.
     * @param proposalIds Ordered approved slate proposals to include.
     * @return roundId Newly assigned slate-round identifier.
     */
    function _createSlateRound(
        CommunityTypes.ProposalOrigin origin,
        uint256[] calldata proposalIds
    ) private returns (uint256 roundId) {
        if (proposalIds.length == 0 || proposalIds.length > MAX_SLATE_PROPOSALS_PER_ROUND) {
            revert InvalidCommunityConfig("round size");
        }

        roundId = ++roundCount;
        uint64 startTime = _communityTime();
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        round.origin = origin;
        round.startTime = startTime;
        round.endTime = startTime + uint64(roundVotingDuration);
        activeSlateRoundCount += 1;

        for (uint256 i; i < proposalIds.length; ++i) {
            uint256 proposalId = proposalIds[i];
            if (proposalId == 0 || proposalId > proposalCount) {
                revert CommunityProposalNotFound(proposalId);
            }
            if (proposalIncludedInRound[roundId][proposalId]) {
                revert InvalidRoundProposal(proposalId);
            }

            CommunityTypes.Proposal storage proposal = proposals[proposalId];
            if (
                proposal.origin != origin ||
                proposal.mode != CommunityTypes.ProposalMode.Slate ||
                proposal.status != CommunityTypes.ProposalStatus.ApprovedForRound ||
                proposal.assignedRoundId != 0
            ) {
                revert InvalidRoundProposal(proposalId);
            }

            proposal.assignedRoundId = roundId;
            proposal.status = CommunityTypes.ProposalStatus.InRoundVoting;
            proposalIncludedInRound[roundId][proposalId] = true;
            proposalIdsByRound[roundId].push(proposalId);
        }

        emit SlateRoundCreated(roundId, origin, round.endTime);
    }
}
