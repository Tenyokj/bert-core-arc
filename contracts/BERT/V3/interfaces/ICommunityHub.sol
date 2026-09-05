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

import {CommunityTypes} from "../utils/CommunityTypes.sol";

/**
 * @title ICommunityHub
 * @notice Read-only CommunityHub surface required by CommunityTreasury.
 * @dev Keeps Treasury and its unit-test double independent from the full CommunityHub implementation.
 */
interface ICommunityHub {

    /**
     * @notice Returns the account that created this community Hub.
     */
    function creator() external view returns (address);

    /**
     * @notice Returns the Treasury that this Hub was constructed to govern.
     */
    function communityTreasury() external view returns (address);

    /**
     * @notice Returns the hash of the immutable CommunityConfig used at construction.
     */
    function configHash() external view returns (bytes32);

    /**
     * @notice Emitted whenever the lifecycle status changes.
     * @param newStatus New Active, Paused, or Archived status.
     */
    event CommunityStatusChanged(CommunityTypes.CommunityStatus newStatus);
    /**
     * @notice Emitted when a community permanently closes governance after all fund-bearing flows settle.
     */
    event CommunityArchived(uint256 archivedAt);

    /** @notice Emitted when an account receives the local admin role. @param admin New admin address. */
    event AdminAdded(address indexed admin);
    /** @notice Emitted when an account loses the local admin role. @param admin Removed admin address. */
    event AdminRemoved(address indexed admin);
    /** @notice Emitted when an account receives the local validator role. @param validator New validator address. */
    event ValidatorAdded(address indexed validator);
    /** @notice Emitted when an account loses the local validator role. @param validator Removed validator address. */
    event ValidatorRemoved(address indexed validator);

    /** @notice Emitted after membership stake is locked. @param member Joining address. @param stake Locked USDC amount. */
    event MemberJoined(address indexed member, uint256 stake);
    /** @notice Emitted when a member starts exit cooldown. @param member Exiting address. @param availableAt Community time at which exit may finalize. */
    event MembershipExitRequested(address indexed member, uint256 availableAt);
    /** @notice Emitted after a member exits and receives stake. @param member Exited address. @param returnedStake Returned USDC amount. */
    event MembershipExited(address indexed member, uint256 returnedStake);

    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed creator,
        CommunityTypes.ProposalOrigin origin
    );
    /** @notice Emitted for one validator review. @param proposalId Reviewed proposal. @param validator Reviewer. @param approved Review direction. */
    event ValidatorDecisionCast(uint256 indexed proposalId, address indexed validator, bool approved);
    /** @notice Emitted when member proposal review reaches terminal outcome. @param proposalId Reviewed proposal. @param approved Final outcome. */
    event ProposalValidationFinalized(uint256 indexed proposalId, bool approved);

    /** @notice Emitted when binary voting begins. @param proposalId Open proposal. @param votingDeadline Community-clock close time. */
    event BinaryVotingOpened(uint256 indexed proposalId, uint256 votingDeadline);
    event BinaryVoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        CommunityTypes.VoteChoice choice,
        uint256 amount
    );
    /** @notice Emitted when binary Treasury settlement completes. @param proposalId Settled proposal. @param accepted Whether YES won. */
    event BinaryProposalSettled(uint256 indexed proposalId, bool accepted);

    /**
     * @notice Emitted when an admin opens a single-choice slate round.
     */
    event SlateRoundCreated(
        uint256 indexed roundId,
        CommunityTypes.ProposalOrigin origin,
        uint256 votingDeadline
    );
    /**
     * @notice Emitted when a member commits USDC to one proposal in a slate round.
     */
    event SlateRoundVoteCast(
        uint256 indexed roundId,
        uint256 indexed proposalId,
        address indexed voter,
        uint256 amount
    );
    /**
     * @notice Emitted when a completed slate round has selected and settled its winner.
     */
    event SlateRoundSettled(
        uint256 indexed roundId,
        uint256 indexed winningProposalId,
        uint256 winningVotes,
        uint256 totalVotes
    );

    /** @notice Emitted when a winning member proposal earns local progression. @param proposalId Winning proposal. @param member Winning author. @param totalPoints New point total. */
    event ProposalPointAwarded(uint256 indexed proposalId, address indexed member, uint256 totalPoints);
    /**
     * @notice Emitted when a member reaches the local threshold for validator nomination.
     */
    event ValidatorEligibilityReached(address indexed member, uint256 totalPoints);
    /** @notice Emitted when validator activity is finalized. @param epochId Finalized epoch. @param activeValidatorCount Reward-eligible validator count. */
    event ValidatorRewardEpochFinalized(uint256 indexed epochId, uint256 activeValidatorCount);
    /** @notice Emitted when a validator epoch opens. @param epochId New epoch. @param startTime Community-clock start. @param endTime Community-clock end. */
    event ValidatorRewardEpochRolled(uint256 indexed epochId, uint256 startTime, uint256 endTime);

    /**
     * @notice Reports whether an address currently holds the local admin role.
     * @param account Address to inspect.
     */
    function isAdminAccount(address account) external view returns (bool);

    /**
     * @notice Returns the community lifecycle status.
     */
    function communityStatus()
        external
        view
        returns (CommunityTypes.CommunityStatus);

    /**
     * @notice Returns the percentage of every local successful settlement reserved for validators, in basis points.
     */
    function validatorRewardShareBps() external view returns (uint256);

    /**
     * @notice Returns the number of admin approvals required to execute a withdrawal.
     */
    function adminApprovalThreshold() external view returns (uint256);

    /**
     * @notice Returns a member's recorded binary vote choice and stake.
     * @param proposalId Existing binary proposal identifier.
     * @param voter Member address whose vote is queried.
     * @return choice Recorded vote direction.
     * @return stake USDC stake committed to that direction.
     */
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake);

    /**
     * @notice Reports whether a validator reached the activity threshold in an epoch.
     * @param epochId Validator reward epoch identifier.
     * @param validator Validator address.
     * @return True when the validator is eligible to claim that epoch's equal reward.
     */
    function isValidatorActiveForEpoch(uint256 epochId, address validator)
        external
        view
        returns (bool);

}
