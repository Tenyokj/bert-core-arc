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

import {ICommunityFactory} from "../interfaces/ICommunityFactory.sol";
import {IHumanVerifier} from "../../interfaces/IHumanVerifier.sol";
import {ICommunityHub} from "../interfaces/ICommunityHub.sol";
import {ICommunityHubV31} from "../interfaces/ICommunityHubV31.sol";
import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";
import {ICommunityMilestoneTreasury} from "../interfaces/ICommunityMilestoneTreasury.sol";
import {ICommunityWinnerSnapshot} from "../interfaces/ICommunityWinnerSnapshot.sol";
import {ICommunityMilestoneManager} from "../interfaces/ICommunityMilestoneManager.sol";
import {CommunityTypes} from "../libraries/CommunityTypes.sol";
import {CommunityAdminActions, ICommunityAdminActionTarget} from "../libraries/CommunityAdminActions.sol";
import {CommunityMembershipModule} from "../modules/CommunityMembershipModule.sol";
import {CommunityProposalModule} from "../modules/CommunityProposalModule.sol";
import {CommunityVotingModule} from "../modules/CommunityVotingModule.sol";
import {CommunityWinnerSnapshot} from "../modules/CommunityWinnerSnapshot.sol";
import {CommunityMilestoneManager} from "../modules/CommunityMilestoneManager.sol";
import {CommunityMembershipModuleDeployer} from "../modules/deployers/CommunityMembershipModuleDeployer.sol";
import {CommunityProposalModuleDeployer} from "../modules/deployers/CommunityProposalModuleDeployer.sol";
import {CommunityVotingModuleDeployer} from "../modules/deployers/CommunityVotingModuleDeployer.sol";
import {CommunityMilestoneModuleDeployer} from "../modules/deployers/CommunityMilestoneModuleDeployer.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title CommunityHub
 * @notice Thin V3.1 Community facade: lifecycle, admin quorum and safe module routing.
 * @dev Membership, proposal validation, voting and execution reviews each own
 *      their storage in a dedicated module. This contract deliberately retains
 *      only cross-module invariants and pause-adjusted governance time.
 *
 *      The immutable execution recipient is selected at Community creation,
 *      normally an administration/team multisig. It cannot be redirected
 *      after members have voted funds into a proposal.
 *
 * @custom:version 2.1.0
 */
contract CommunityHub is ICommunityHub, ICommunityHubV31, ICommunityAdminActionTarget, ReentrancyGuard {

    /* ========== IMMUTABLE COMMUNITY CONFIGURATION ========== */

    /// @notice Wallet that created this Community through CommunityFactory.
    /// @dev Only this address may activate its Factory-reserved Treasury.
    address public immutable override creator;

    /// @notice Sole USDC custodian for this Community.
    /// @dev Kept private so every user-facing asset action is routed through a
    ///      narrow module rather than exposing Treasury authority from the Hub.
    ICommunityTreasury private immutable treasury;

    /// @notice Hash of the complete immutable Community configuration.
    /// @dev CommunityFactory checks this during activation to prevent config substitution.
    bytes32 public immutable override configHash;

    /// @notice Proposal-point threshold that makes an inactive account eligible for validator nomination.
    uint256 public immutable override validatorProposalPointsThreshold;

    /// @notice Basis-point share of successful Member-origin votes reserved for validator epochs.
    uint256 public immutable override validatorRewardShareBps;

    /// @notice Immutable number of Admin approvals required for a control-plane action.
    uint256 public immutable override(ICommunityHub, ICommunityAdminActionTarget) adminApprovalThreshold;

    /* ========== COMMUNITY LIFECYCLE ========== */

    /// @notice Current lifecycle state: Active, Paused, or Archived.
    CommunityTypes.CommunityStatus public override(ICommunityHub, ICommunityAdminActionTarget) communityStatus;
    /// @notice Wall-clock timestamp at which the current pause began; zero when active.
    uint64 public pausedAt;
    /// @notice Final pause-adjusted Community timestamp frozen when the Community is archived.
    uint64 public archivedAt;
    /// @notice Aggregate wall-clock seconds excluded from all Community deadlines.
    uint256 public totalPausedDuration;

    /* ========== MODULE ADDRESSES ========== */

    /// @notice Module that owns roles, membership stake, and exit obligations.
    CommunityMembershipModule public immutable membership;
    /// @notice Module that owns proposal state and validator-review epochs.
    CommunityProposalModule public immutable proposals;
    /// @notice Module that owns binary/slate vote state and settlement.
    CommunityVotingModule public immutable voting;
    /// @notice Module that seals winning-supporter weight before milestone review.
    CommunityWinnerSnapshot public immutable winnerSnapshot;
    /// @notice Module that releases execution tranches and failure refunds.
    CommunityMilestoneManager public immutable milestones;

    /* ========== ACCESS CONTROL ========== */

    /// @notice Restricts a call to a currently active Community.
    /// @dev Paused Communities stop all governance actions; archived Communities
    ///      allow only explicitly documented post-archive claims/finalization.
    modifier onlyActiveCommunity() {
        if (communityStatus != CommunityTypes.CommunityStatus.Active) {
            if (communityStatus == CommunityTypes.CommunityStatus.Paused) revert CommunityIsPaused();
            revert CommunityIsArchived();
        }
        _;
    }

    /// @notice Blocks actions after permanent Community archival.
    modifier onlyNotArchived() {
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
        _;
    }

    /// @notice Restricts a call to a local Community Admin.
    modifier onlyAdmin() {
        if (!membership.isAdmin(msg.sender)) revert NotCommunityAdmin(msg.sender);
        _;
    }

    /// @notice Restricts a call to a local Community validator.
    modifier onlyValidator() {
        if (!membership.isValidator(msg.sender)) revert NotCommunityValidator(msg.sender);
        _;
    }

    /// @notice Restricts a call to an active stake-backed Community member.
    modifier onlyMember() {
        if (!membership.isActiveMember(msg.sender)) revert NotCommunityMember(msg.sender);
        _;
    }

    /// @notice Restricts a control-plane action to a quorum-approved self-call.
    /// @dev CommunityAdminActions performs the external self-call only after
    ///      the immutable Admin quorum has approved the request.
    modifier onlySelf() {
        if (msg.sender != address(this)) revert NotCommunityHub(msg.sender);
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    /**
     * @notice Creates a thin V3.1 Hub and deploys its dedicated runtime modules.
     * @dev The Factory reserves `communityTreasury_` first. This constructor
     *      reads the Factory-bound deployer addresses from that Treasury, which
     *      makes a forged Hub unable to select replacement modules. The Factory
     *      subsequently verifies `creator`, Treasury, and `configHash` before
     *      binding Treasury authorities exactly once.
     * @param config_ Immutable Community rules, assets, roles, durations, and execution recipient.
     * @param communityTreasury_ Factory-reserved Treasury that custody-holds all Community USDC.
     * @param creator_ Account that reserved the Treasury and is permitted to activate this Hub.
     */
    constructor(CommunityTypes.CommunityConfig memory config_, ICommunityTreasury communityTreasury_, address creator_) {
        _validateConfig(config_, communityTreasury_, creator_);
        creator = creator_;
        treasury = communityTreasury_;
        configHash = keccak256(abi.encode(config_));
        validatorProposalPointsThreshold = config_.validatorProposalPointsThreshold;
        validatorRewardShareBps = config_.validatorRewardShareBps;
        adminApprovalThreshold = config_.adminApprovalThreshold;
        communityStatus = CommunityTypes.CommunityStatus.Active;

        ICommunityFactory factory = ICommunityFactory(communityTreasury_.factory());
        address verifier = factory.humanVerifier();
        uint64 startTime = uint64(block.timestamp);
        membership = CommunityMembershipModuleDeployer(factory.membershipModuleDeployer()).deploy(
            address(this), communityTreasury_, IHumanVerifier(verifier), config_.entryStakeUSDC,
            config_.membershipExitCooldown, config_.validatorProposalPointsThreshold,
            config_.initialAdmins, config_.initialValidators
        );
        proposals = CommunityProposalModuleDeployer(factory.proposalModuleDeployer()).deploy(
            address(this), communityTreasury_, membership, config_.proposalBondUSDC,
            config_.validatorApprovalThreshold, config_.validationWindow,
            config_.validatorRewardEpoch, config_.validatorActiveThresholdBps, startTime
        );
        voting = CommunityVotingModuleDeployer(factory.votingModuleDeployer()).deploy(
            address(this), communityTreasury_, membership, proposals, config_.voteMinStakeUSDC,
            config_.binaryVotingDuration, config_.roundVotingDuration,
            config_.binaryRejectionFeeBps, config_.validatorRewardShareBps
        );
        (winnerSnapshot, milestones) = CommunityMilestoneModuleDeployer(factory.milestoneModuleDeployer()).deploy(
            address(this), address(voting), config_.executionRecipient,
            ICommunityMilestoneTreasury(address(communityTreasury_)),
            config_.milestoneReviewDuration, config_.milestoneProofDuration
        );

        membership.setOperationalModules(address(proposals), address(voting));
        proposals.setVotingModule(address(voting));
        voting.setMilestoneModules(
            ICommunityWinnerSnapshot(address(winnerSnapshot)),
            ICommunityMilestoneManager(address(milestones))
        );
    }

    /* ========== MODULE AND GOVERNANCE VIEWS ========== */

    /** @notice Returns the Community's sole USDC Treasury. @return Treasury contract address. */
    function communityTreasury() external view override returns (address) { return address(treasury); }
    /** @notice Returns the membership module. @return Module contract address. */
    function membershipModule() external view override returns (address) { return address(membership); }
    /** @notice Returns the proposal module. @return Module contract address. */
    function proposalModule() external view override returns (address) { return address(proposals); }
    /** @notice Returns the voting module. @return Module contract address. */
    function votingModule() external view override returns (address) { return address(voting); }
    /** @notice Returns the milestone manager. @return Module contract address. */
    function milestoneManager() external view override returns (address) { return address(milestones); }

    /** @notice Reports whether `account` is a local Admin. @param account Address to inspect. */
    function isAdminAccount(address account) external view override returns (bool) { return membership.isAdmin(account); }
    /** @notice Returns the role-incarnation nonce used to invalidate stale tranche approvals. @param account Admin wallet to inspect. @return Current membership role nonce. */
    function adminRoleNonce(address account) external view returns (uint256) { return membership.adminRoleNonce(account); }
    /** @notice Reports whether `account` is a local validator. @param account Address to inspect. */
    function isValidatorAccount(address account) external view returns (bool) { return membership.isValidator(account); }
    /** @notice Reports whether an inactive account can be nominated validator. @param account Address to inspect. */
    function isValidatorEligible(address account) external view returns (bool) { return membership.isValidatorEligible(account); }
    /** @notice Returns the pause-adjusted timestamp used by every Community deadline. @return Current Community clock time. */
    function communityTime() public view override(ICommunityAdminActionTarget) returns (uint64) {
        return _communityTime();
    }
    /** @notice Returns one membership record. @param account Address to inspect. @return Member lifecycle and stake data. */
    function getMember(address account) external view returns (CommunityTypes.MemberInfo memory) { return membership.getMember(account); }
    /** @notice Returns one proposal record. @param proposalId Proposal identifier. @return Proposal lifecycle and vote data. */
    function getProposal(uint256 proposalId) external view returns (CommunityTypes.Proposal memory) { return proposals.getProposal(proposalId); }
    /** @notice Returns one slate-round record. @param roundId Round identifier. @return Round lifecycle and settlement data. */
    function getRound(uint256 roundId) external view returns (CommunityTypes.CommunityRound memory) { return voting.getRound(roundId); }
    /**
     * @notice Returns proposal IDs in their deterministic slate-round order.
     * @param roundId Existing slate-round identifier.
     * @return Ordered proposal identifiers used for winner tie-breaking.
     */
    function getRoundProposalIds(uint256 roundId) external view returns (uint256[] memory) { return voting.getRoundProposalIds(roundId); }
    /**
     * @notice Returns one member's binary vote direction and escrowed USDC.
     * @param proposalId Binary proposal identifier.
     * @param voter_ Voter address to inspect.
     * @return choice Recorded vote direction, or None when no vote exists.
     * @return stake USDC amount committed by `voter_`.
     */
    function getBinaryVote(uint256 proposalId, address voter_) external view override returns (CommunityTypes.VoteChoice choice, uint256 stake) {
        return voting.getBinaryVote(proposalId, voter_);
    }
    /**
     * @notice Returns one member's selected proposal and escrowed USDC in a slate round.
     * @param roundId Slate-round identifier.
     * @param voter_ Voter address to inspect.
     * @return proposalId Selected proposal, or zero when no vote exists.
     * @return stake USDC amount committed by `voter_`.
     */
    function getSlateVote(uint256 roundId, address voter_) external view returns (uint256 proposalId, uint256 stake) {
        return voting.getSlateVote(roundId, voter_);
    }
    /** @notice Returns validator activity data for an epoch. @param epochId Epoch identifier. @return Epoch record. */
    function getValidatorRewardEpoch(uint256 epochId) external view returns (CommunityTypes.ValidatorRewardEpoch memory) {
        return proposals.getValidatorRewardEpoch(epochId);
    }
    /**
     * @notice Reports whether a validator completed the configured share of an epoch's review cases.
     * @param epochId Validator reward epoch identifier.
     * @param validator Validator address to inspect.
     * @return True only after the epoch is finalized and the activity threshold is met.
     */
    function isValidatorActiveForEpoch(uint256 epochId, address validator) external view override returns (bool) {
        return proposals.isValidatorActiveForEpoch(epochId, validator);
    }

    /* ========== ADMIN QUORUM ACTIONS ========== */

    /**
     * @notice Creates an Admin-quorum request for a sensitive Community action.
     * @param action Pause, unpause, archive, roster change, or withdrawal cancellation action.
     * @param target Role recipient or role holder; zero for lifecycle and cancellation actions.
     * @param value Withdrawal request ID for CancelWithdrawal; zero otherwise.
     * @return requestId Identifier of the created request; creator supplies its first approval.
     */
    function createAdminActionRequest(CommunityTypes.AdminActionType action, address target, uint256 value)
        external onlyAdmin onlyNotArchived returns (uint256)
    { return CommunityAdminActions.create(action, target, value); }

    /** @notice Adds the calling Admin's approval to an open request. @param requestId Request identifier. */
    function approveAdminActionRequest(uint256 requestId) external onlyAdmin onlyNotArchived {
        CommunityAdminActions.approve(requestId);
    }

    /**
     * @notice Executes an approved request through a Hub self-call.
     * @dev Reentrancy protection covers the only flow that can change lifecycle
     *      state, roster state, or cancel a Treasury withdrawal.
     * @param requestId Request identifier that has reached immutable Admin quorum.
     */
    function executeAdminActionRequest(uint256 requestId) external onlyAdmin onlyNotArchived nonReentrant {
        CommunityAdminActions.execute(requestId);
    }

    /**
     * @notice Applies one quorum-approved control-plane action.
     * @dev Callable only by `address(this)` via CommunityAdminActions. Archive
     *      is blocked while validation, voting, or execution-plan duties remain.
     * @param action Approved action type.
     * @param target Role target when the action changes the roster.
     * @param value Treasury withdrawal request ID for cancellation.
     */
    function executeAdminAction(CommunityTypes.AdminActionType action, address target, uint256 value) external onlySelf {
        if (action == CommunityTypes.AdminActionType.Pause) {
            if (communityStatus != CommunityTypes.CommunityStatus.Active) revert CommunityNotActive();
            pausedAt = uint64(block.timestamp);
            communityStatus = CommunityTypes.CommunityStatus.Paused;
            emit CommunityStatusChanged(communityStatus);
            return;
        }
        if (action == CommunityTypes.AdminActionType.Unpause) {
            if (communityStatus != CommunityTypes.CommunityStatus.Paused) revert CommunityNotActive();
            totalPausedDuration += block.timestamp - pausedAt;
            pausedAt = 0;
            communityStatus = CommunityTypes.CommunityStatus.Active;
            emit CommunityStatusChanged(communityStatus);
            return;
        }
        if (action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            treasury.cancelWithdrawalRequestByGovernance(value);
            return;
        }
        if (communityStatus != CommunityTypes.CommunityStatus.Active) revert CommunityNotActive();
        if (action == CommunityTypes.AdminActionType.Archive) {
            uint256 unresolved = proposals.pendingValidationProposalCount() + milestones.unresolvedPlanCount();
            if (unresolved != 0 || voting.activeBinaryProposalCount() != 0 || voting.activeSlateRoundCount() != 0) {
                revert CommunityArchiveBlocked(
                    proposals.pendingValidationProposalCount(), voting.activeBinaryProposalCount(),
                    voting.activeSlateRoundCount(), unresolved
                );
            }
            archivedAt = _communityTime();
            communityStatus = CommunityTypes.CommunityStatus.Archived;
            emit CommunityStatusChanged(communityStatus);
            emit CommunityArchived(archivedAt);
            return;
        }
        if (action == CommunityTypes.AdminActionType.AddAdmin) { membership.addAdmin(target); return; }
        if (action == CommunityTypes.AdminActionType.RemoveAdmin) { membership.removeAdmin(target); return; }
        if (proposals.pendingValidationProposalCount() != 0) revert ValidatorSetLocked();
        if (action == CommunityTypes.AdminActionType.AddValidator) {
            if (!membership.isValidatorEligible(target)) {
                revert ValidatorNotEligible(target, membership.getMember(target).proposalPoints, validatorProposalPointsThreshold);
            }
            membership.addValidator(target);
            return;
        }
        if (action == CommunityTypes.AdminActionType.RemoveValidator) { membership.removeValidator(target); return; }
        revert InvalidAdminActionParameters();
    }

    /**
     * @notice Lets a validator resign when no Member proposal is awaiting review.
     * @dev Prevents a validator from escaping an in-flight review set.
     */
    function renounceValidatorRole() external onlyValidator onlyNotArchived {
        if (proposals.pendingValidationProposalCount() != 0) revert ValidatorSetLocked();
        membership.removeValidator(msg.sender);
    }

    /* ========== MEMBERSHIP ========== */

    /** @notice Joins the Community after Treasury pulls the immutable entry stake. */
    function joinCommunity() external onlyActiveCommunity nonReentrant { membership.join(msg.sender, _communityTime()); }
    /** @notice Starts the caller's membership-exit cooldown. */
    function requestMembershipExit() external onlyActiveCommunity onlyMember { membership.requestExit(msg.sender, _communityTime()); }
    /**
     * @notice Releases a requested membership exit once cooldown and obligations clear.
     * @dev A request made before archive may finalize after archive; this avoids
     *      trapping stake while keeping archive itself free of arbitrary exits.
     */
    function finalizeMembershipExit() external onlyMember nonReentrant {
        membership.finalizeExit(msg.sender, _communityTime(), communityStatus == CommunityTypes.CommunityStatus.Archived);
    }

    /* ========== PROPOSAL CREATION AND VALIDATION ========== */

    /**
     * @notice Creates an Admin-owned binary proposal, immediately eligible for voting.
     * @param title Short proposal title.
     * @param description Human-readable proposal body.
     * @param metadataURI Off-chain immutable metadata reference.
     * @return New proposal identifier.
     */
    function createAdminProposal(string calldata title, string calldata description, string calldata metadataURI)
        external onlyAdmin onlyActiveCommunity returns (uint256)
    { return proposals.createAdminBinary(msg.sender, title, description, metadataURI, _communityTime()); }

    /**
     * @notice Creates a Member-owned binary proposal and starts validator review.
     * @param title Short proposal title.
     * @param description Human-readable proposal body.
     * @param metadataURI Off-chain immutable metadata reference.
     * @return New proposal identifier whose bond remains locked through review/settlement.
     */
    function createMemberProposal(string calldata title, string calldata description, string calldata metadataURI)
        external onlyMember onlyActiveCommunity nonReentrant returns (uint256)
    { return proposals.createMemberBinary(msg.sender, title, description, metadataURI, _communityTime()); }

    /** @notice Creates an Admin-owned proposal for a slate round. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @return New proposal identifier. */
    function createAdminSlateProposal(string calldata title, string calldata description, string calldata metadataURI)
        external onlyAdmin onlyActiveCommunity returns (uint256)
    { return proposals.createAdminSlate(msg.sender, title, description, metadataURI, _communityTime()); }

    /** @notice Creates a Member-owned slate proposal and starts validator review. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @return New proposal identifier. */
    function createMemberSlateProposal(string calldata title, string calldata description, string calldata metadataURI)
        external onlyMember onlyActiveCommunity nonReentrant returns (uint256)
    { return proposals.createMemberSlate(msg.sender, title, description, metadataURI, _communityTime()); }

    /** @notice Records one validator decision. @param proposalId Pending Member proposal. @param approved True to approve, false to reject. */
    function castValidationDecision(uint256 proposalId, bool approved) external onlyValidator onlyActiveCommunity {
        proposals.castValidationDecision(msg.sender, proposalId, approved, _communityTime());
    }
    /** @notice Finalizes a validation window after expiry. @param proposalId Pending Member proposal. */
    function finalizeMemberProposalValidation(uint256 proposalId) external onlyActiveCommunity {
        proposals.finalizeExpiredValidation(proposalId, _communityTime());
    }
    /** @notice Finalizes a closed validator reward epoch. @param epochId Epoch to finalize. */
    function finalizeValidatorRewardEpoch(uint256 epochId) external onlyActiveCommunity {
        proposals.finalizeValidatorRewardEpoch(epochId, _communityTime());
    }
    /** @notice Opens the next validator reward epoch when the current epoch has elapsed. */
    function rollValidatorRewardEpoch() external onlyActiveCommunity { proposals.rollValidatorRewardEpoch(_communityTime()); }

    /* ========== BINARY AND SLATE VOTING ========== */

    /** @notice Opens voting on an approved binary proposal. @param proposalId Approved binary proposal identifier. */
    function openBinaryVoting(uint256 proposalId) external onlyAdmin onlyActiveCommunity { voting.openBinaryVoting(msg.sender, proposalId, _communityTime()); }
    /** @notice Commits USDC to a binary YES or NO vote. @param proposalId Open binary proposal. @param choice YES or NO. @param amount USDC commitment. */
    function castBinaryVote(uint256 proposalId, CommunityTypes.VoteChoice choice, uint256 amount) external onlyMember onlyActiveCommunity {
        voting.castBinaryVote(msg.sender, proposalId, choice, amount, _communityTime());
    }
    /** @notice Settles an expired binary vote and starts a plan when YES wins. @param proposalId Binary proposal identifier. */
    function settleBinaryProposal(uint256 proposalId) external onlyActiveCommunity { voting.settleBinaryProposal(proposalId, _communityTime()); }
    /** @notice Creates an Admin-origin slate round. @param proposalIds Approved Admin slate proposal IDs. @return New round identifier. */
    function createAdminSlateRound(uint256[] calldata proposalIds) external onlyAdmin onlyActiveCommunity returns (uint256) {
        return voting.createAdminSlateRound(msg.sender, proposalIds, _communityTime());
    }
    /** @notice Creates a Member-origin slate round. @param proposalIds validator-approved Member slate proposal IDs. @return New round identifier. */
    function createMemberSlateRound(uint256[] calldata proposalIds) external onlyAdmin onlyActiveCommunity returns (uint256) {
        return voting.createMemberSlateRound(msg.sender, proposalIds, _communityTime());
    }
    /** @notice Commits USDC to one proposal in an open slate round. @param roundId Open round. @param proposalId Selected round proposal. @param amount USDC commitment. */
    function castSlateRoundVote(uint256 roundId, uint256 proposalId, uint256 amount) external onlyMember onlyActiveCommunity {
        voting.castSlateRoundVote(msg.sender, roundId, proposalId, amount, _communityTime());
    }
    /** @notice Settles an expired slate round and starts a plan for its winner. @param roundId Slate-round identifier. */
    function settleSlateRound(uint256 roundId) external onlyActiveCommunity { voting.settleSlateRound(roundId, _communityTime()); }
    /** @notice Clears a settled binary vote lock once any reviewer duty is complete. @param proposalId Settled binary proposal. */
    function clearSettledVoteLock(uint256 proposalId) external { voting.clearSettledBinaryVoteLock(msg.sender, proposalId); }
    /** @notice Clears a settled slate vote lock once any reviewer duty is complete. @param roundId Settled slate round. */
    function clearSettledRoundVoteLock(uint256 roundId) external { voting.clearSettledRoundVoteLock(msg.sender, roundId); }

    /* ========== EXECUTION PLANS AND MILESTONES ========== */

    /** @notice Approves the fixed pending tranche using the caller's current Admin role. @param planId Execution-plan ID. */
    function approveExecutionTranche(uint256 planId) external onlyAdmin onlyActiveCommunity {
        milestones.approveExecutionTranche(msg.sender, planId, _communityTime());
    }
    /** @notice Executes a quorum-approved tranche; anyone may relay the immutable payment. @param planId Execution-plan ID. @param approvingAdmins Strictly ascending list of current approving Admins, exactly matching the threshold. */
    function executeExecutionTranche(uint256 planId, address[] calldata approvingAdmins) external onlyActiveCommunity {
        milestones.executeExecutionTranche(planId, approvingAdmins, _communityTime());
    }
    /** @notice Fails a plan whose pending tranche was not paid before its seven-day deadline. @param planId Execution-plan ID. */
    function expireExecutionTranche(uint256 planId) external onlyActiveCommunity {
        milestones.expireExecutionTranche(planId, _communityTime());
    }

    /** @notice Submits evidence for the current execution milestone. @param planId Winning proposal/plan identifier. @param evidenceHash Hash of the off-chain evidence bundle. */
    function submitMilestoneProof(uint256 planId, bytes32 evidenceHash) external onlyActiveCommunity {
        milestones.submitMilestoneProof(msg.sender, planId, evidenceHash, _communityTime());
    }
    /** @notice Casts a winning-supporter review decision. @param planId Plan identifier. @param approved True for approval, false for rejection. */
    function castMilestoneReview(uint256 planId, bool approved) external onlyActiveCommunity {
        milestones.castMilestoneReview(msg.sender, planId, approved, _communityTime());
    }
    /** @notice Finalizes an elapsed review window. @param planId Plan identifier. */
    function finalizeMilestoneReview(uint256 planId) external onlyActiveCommunity {
        milestones.finalizeMilestoneReview(planId, _communityTime());
    }
    /** @notice Reopens a rejected first proof after correction cooldown. @param planId Plan identifier. */
    function reopenAfterCorrection(uint256 planId) external onlyActiveCommunity {
        milestones.reopenAfterCorrection(msg.sender, planId, _communityTime());
    }
    /** @notice Fails a plan whose executor missed its proof deadline. @param planId Plan identifier. */
    function failExpiredPlan(uint256 planId) external onlyActiveCommunity {
        milestones.failExpiredPlan(planId, _communityTime());
    }
    /** @notice Claims a pro-rata failed-plan refund; remains available after archive. @param planId Failed plan identifier. */
    function claimFailedPlanRefund(uint256 planId) external {
        milestones.claimFailedPlanRefund(msg.sender, planId);
    }

    /* ========== INTERNAL CLOCK AND VALIDATION ========== */

    /**
     * @notice Calculates the pause-adjusted Community clock.
     * @dev Every module receives this value rather than `block.timestamp`; a
     *      pause therefore freezes voting, validation, proof, and review time.
     * @return Community timestamp, frozen at `archivedAt` after archive.
     */
    function _communityTime() private view returns (uint64) {
        if (communityStatus == CommunityTypes.CommunityStatus.Archived) return archivedAt;
        if (communityStatus == CommunityTypes.CommunityStatus.Paused) return uint64(uint256(pausedAt) - totalPausedDuration);
        return uint64(block.timestamp - totalPausedDuration);
    }

    /**
     * @notice Validates immutable configuration before any module is deployed.
     * @dev Bounds ensure every successful vote can create an executable plan,
     *      a reviewer window is meaningful, and local quorums are achievable.
     * @param config_ Candidate immutable Community configuration.
     * @param treasury_ Factory-reserved Treasury paired with this Hub.
     * @param creator_ Factory-recorded Community creator.
     */
    function _validateConfig(CommunityTypes.CommunityConfig memory config_, ICommunityTreasury treasury_, address creator_) private pure {
        if (address(treasury_) == address(0)) revert ZeroAddress("communityTreasury");
        if (creator_ == address(0)) revert ZeroAddress("creator");
        if (config_.usdc == address(0) || config_.globalBertReserve == address(0)) revert InvalidCommunityConfig("asset configuration");
        if (config_.initialAdmins.length == 0 || config_.initialValidators.length == 0 || config_.initialValidators.length > 50) {
            revert InvalidCommunityConfig("initial roles");
        }
        if (
            config_.entryStakeUSDC == 0 || config_.proposalBondUSDC == 0 || config_.voteMinStakeUSDC == 0
                || config_.membershipExitCooldown == 0 || config_.validationWindow == 0
                || config_.binaryVotingDuration == 0 || config_.roundVotingDuration == 0 || config_.validatorRewardEpoch == 0
        ) revert InvalidCommunityConfig("durations or stakes");
        if (config_.adminApprovalThreshold == 0 || config_.adminApprovalThreshold > config_.initialAdmins.length) {
            revert InvalidCommunityConfig("adminApprovalThreshold");
        }
        if (config_.validatorApprovalThreshold == 0 || config_.validatorApprovalThreshold > config_.initialValidators.length) {
            revert InvalidCommunityConfig("validatorApprovalThreshold");
        }
        if (config_.validatorRewardShareBps >= 10_000 || config_.validatorActiveThresholdBps == 0 || config_.validatorActiveThresholdBps > 10_000) {
            revert InvalidCommunityConfig("validator configuration");
        }
        if (config_.executionRecipient == address(0)) revert ZeroAddress("executionRecipient");
        if (config_.milestoneReviewDuration < 1 days || config_.milestoneReviewDuration > 14 days || config_.milestoneProofDuration == 0) {
            revert InvalidCommunityConfig("milestone durations");
        }
    }
}
