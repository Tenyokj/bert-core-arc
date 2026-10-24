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

import {IHumanVerifier} from "../../interfaces/IHumanVerifier.sol";
import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";
import {ICommunityMembershipModule} from "../interfaces/ICommunityMembershipModule.sol";
import {ICommunityVotingModule} from "../interfaces/ICommunityVotingModule.sol";
import {CommunityTypes} from "../libraries/CommunityTypes.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title CommunityMembershipModule
 * @notice Owns one Community's roles, stake-backed membership and exit locks.
 * @dev Calls are routed by the CommunityHub so lifecycle checks remain in one
 *      orchestration point, while this module enforces all local invariants.
 *      A wallet can hold only one active Community role: Admin, validator, or
 *      stake-backed member. Exit is blocked until every proposal and vote duty
 *      recorded against that member has been resolved.
 *
 * @custom:version 1.1.0
 */
contract CommunityMembershipModule is ICommunityMembershipModule {
    /* ========== CONSTANTS ========== */

    /// @notice Maximum local validator roster size, keeping epoch settlement bounded.
    uint256 public constant MAX_ACTIVE_VALIDATORS = 50;

    /* ========== IMMUTABLE DEPENDENCIES AND CONFIGURATION ========== */

    /// @notice Hub allowed to forward member-controlled Community operations.
    address public immutable hub;
    /// @notice Sole USDC custodian used for membership stake lock and release.
    ICommunityTreasury public immutable treasury;
    /// @notice Shared verifier used to gate new membership to verified humans.
    IHumanVerifier public immutable humanVerifier;
    /// @notice USDC stake required for joining this Community.
    uint256 public immutable entryStakeUSDC;
    /// @notice Pause-adjusted seconds a requested exit must wait while active.
    uint256 public immutable membershipExitCooldown;
    /// @notice Proposal points needed before an inactive account can become validator-eligible.
    uint256 public immutable validatorProposalPointsThreshold;

    /* ========== ROLE AND MEMBER STORAGE ========== */

    /// @dev Local Admin role by account. Admins never overlap with members or validators.
    mapping(address account => bool) private admins;
    /// @notice Incarnation of an Admin role; removal/reappointment invalidates old tranche approvals.
    mapping(address account => uint256 nonce) public override adminRoleNonce;
    /// @dev Local validator role by account. Validators never overlap with members or Admins.
    mapping(address account => bool) private validators;
    /// @dev Membership record including refundable stake, exit state, and historical proposal points.
    mapping(address account => CommunityTypes.MemberInfo) private members;
    /// @dev Count of unresolved Member-proposal duties; prevents a strategic exit.
    mapping(address account => uint256 count) private obligations;

    /* ========== MODULE CONFIGURATION ========== */

    /// @notice Current number of active Admins; never permitted to fall below one.
    uint256 public override adminCount;
    /// @notice Current number of active validators.
    uint256 public override validatorCount;
    /// @notice Proposal module permitted to create/clear a proposal-author obligation.
    address public proposalModule;
    /// @notice Voting module permitted to create/clear vote-related exit obligations.
    address public votingModule;

    /* ========== EVENTS ========== */

    event MemberJoined(address indexed member, uint256 stake);
    event MembershipExitRequested(address indexed member, uint256 availableAt);
    event MembershipExited(address indexed member, uint256 stake);
    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);
    event ValidatorAdded(address indexed account);
    event ValidatorRemoved(address indexed account);
    event ProposalPointAwarded(uint256 indexed proposalId, address indexed member, uint256 totalPoints);
    event ValidatorEligibilityReached(address indexed member, uint256 totalPoints);
    event OperationalModulesConfigured(address indexed proposalModule, address indexed votingModule);

    /* ========== ACCESS CONTROL ========== */

    /// @notice Restricts a call to the immutable CommunityHub facade.
    modifier onlyHub() {
        if (msg.sender != hub) revert NotCommunityHub(msg.sender);
        _;
    }

    /// @notice Restricts obligation updates to the Hub, Proposal module, or Voting module.
    /// @dev The module addresses are configured exactly once after all modules deploy.
    modifier onlyObligationAuthority() {
        if (msg.sender != hub && msg.sender != proposalModule && msg.sender != votingModule) {
            revert NotCommunityHub(msg.sender);
        }
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    /**
     * @notice Creates one Community's isolated membership and local-role registry.
     * @param hub_ CommunityHub that exclusively routes mutating calls.
     * @param treasury_ Treasury that custody-holds entry stakes.
     * @param humanVerifier_ Proof-of-personhood verifier required for joining.
     * @param entryStakeUSDC_ Immutable USDC stake required from each member.
     * @param membershipExitCooldown_ Community-clock delay before an active exit may finalize.
     * @param validatorProposalPointsThreshold_ Points needed for future validator nomination eligibility.
     * @param initialAdmins Initial local Admin roster; must include the Community creator upstream.
     * @param initialValidators Initial local validator roster, capped by MAX_ACTIVE_VALIDATORS.
     */
    constructor(
        address hub_,
        ICommunityTreasury treasury_,
        IHumanVerifier humanVerifier_,
        uint256 entryStakeUSDC_,
        uint256 membershipExitCooldown_,
        uint256 validatorProposalPointsThreshold_,
        address[] memory initialAdmins,
        address[] memory initialValidators
    ) {
        if (hub_ == address(0)) revert ZeroAddress("hub");
        if (address(treasury_) == address(0)) revert ZeroAddress("treasury");
        if (address(humanVerifier_) == address(0)) revert ZeroAddress("humanVerifier");
        if (entryStakeUSDC_ == 0 || validatorProposalPointsThreshold_ == 0) {
            revert InvalidCommunityConfig("membership configuration");
        }
        hub = hub_;
        treasury = treasury_;
        humanVerifier = humanVerifier_;
        entryStakeUSDC = entryStakeUSDC_;
        membershipExitCooldown = membershipExitCooldown_;
        validatorProposalPointsThreshold = validatorProposalPointsThreshold_;

        for (uint256 i; i < initialAdmins.length; ++i) _addAdmin(initialAdmins[i]);
        if (adminCount == 0) revert InvalidCommunityConfig("initialAdmins");
        for (uint256 i; i < initialValidators.length; ++i) _addValidator(initialValidators[i]);
    }

    /* ========== ROLE AND MEMBERSHIP VIEWS ========== */

    /** @notice Reports whether an account has the local Admin role. @param account Address to inspect. */
    function isAdmin(address account) external view returns (bool) {
        return admins[account];
    }

    /** @notice Reports whether an account has the local validator role. @param account Address to inspect. */
    function isValidator(address account) external view returns (bool) {
        return validators[account];
    }

    /** @notice Reports whether an account has active stake-backed membership. @param account Address to inspect. */
    function isActiveMember(address account) external view returns (bool) {
        return members[account].active;
    }

    /** @notice Reports whether a member requested exit and therefore cannot begin new governance duties. @param account Address to inspect. */
    function hasPendingExit(address account) external view returns (bool) {
        return members[account].exitRequestedAt != 0;
    }

    /** @notice Returns the complete local membership record. @param account Address to inspect. @return Member stake, lifecycle, and proposal-point data. */
    function getMember(address account) external view returns (CommunityTypes.MemberInfo memory) {
        return members[account];
    }

    /** @notice Returns outstanding proposal-author obligations. @param account Address to inspect. @return Count that blocks exit. */
    function unresolvedObligationCount(address account) external view returns (uint256) {
        return obligations[account];
    }

    /** @notice Reports whether an inactive account earned enough proposal points for validator nomination. @param account Address to inspect. */
    function isValidatorEligible(address account) external view returns (bool) {
        return !members[account].active && members[account].proposalPoints >= validatorProposalPointsThreshold;
    }

    /* ========== HUB-ROUTED MEMBERSHIP OPERATIONS ========== */

    /**
     * @notice Binds the only modules that may create or clear exit obligations.
     * @dev One-time binding prevents a later Hub/Admin action from granting a
     *      replacement contract power to trap or release member exits.
     * @param proposalModule_ Deployed CommunityProposalModule address.
     * @param votingModule_ Deployed CommunityVotingModule address.
     */
    function setOperationalModules(address proposalModule_, address votingModule_) external onlyHub {
        if (proposalModule != address(0) || votingModule != address(0)) {
            revert CommunityV31ModulesAlreadyConfigured();
        }
        if (
            proposalModule_ == address(0) || votingModule_ == address(0)
                || proposalModule_.code.length == 0 || votingModule_.code.length == 0
        ) revert ZeroAddress("v31Module");
        proposalModule = proposalModule_;
        votingModule = votingModule_;
        emit OperationalModulesConfigured(proposalModule_, votingModule_);
    }

    /**
     * @notice Activates membership after a verified-human wallet provides entry stake.
     * @param account Wallet joining the Community; supplied by the Hub as msg.sender.
     * @param communityTime Pause-adjusted timestamp stored as join time.
     */
    function join(address account, uint64 communityTime) external onlyHub {
        if (account == address(0)) revert ZeroAddress("member");
        if (!humanVerifier.isVerifiedHuman(account)) revert HumanVerificationRequired(account);
        if (members[account].active) revert AlreadyCommunityMember(account);
        if (admins[account] || validators[account]) revert AdminValidatorRoleConflict(account);

        treasury.depositMembershipStake(account, entryStakeUSDC);
        members[account] = CommunityTypes.MemberInfo({
            active: true,
            joinedAt: communityTime,
            exitRequestedAt: 0,
            membershipStake: entryStakeUSDC,
            proposalPoints: members[account].proposalPoints
        });
        emit MemberJoined(account, entryStakeUSDC);
    }

    /**
     * @notice Starts an active member's cooldown without releasing their stake yet.
     * @param account Member requesting exit.
     * @param communityTime Pause-adjusted timestamp used to calculate availability.
     */
    function requestExit(address account, uint64 communityTime) external onlyHub {
        CommunityTypes.MemberInfo storage member = _activeMember(account);
        if (member.exitRequestedAt != 0) revert ExitAlreadyRequested(account);
        member.exitRequestedAt = communityTime;
        emit MembershipExitRequested(account, uint256(communityTime) + membershipExitCooldown);
    }

    /**
     * @notice Releases an exit-requested member's stake after all duties clear.
     * @param account Member whose exit is finalized.
     * @param communityTime Pause-adjusted current timestamp.
     * @param archived True when archive waives the remaining cooldown only.
     */
    function finalizeExit(address account, uint64 communityTime, bool archived) external onlyHub {
        CommunityTypes.MemberInfo storage member = _activeMember(account);
        if (member.exitRequestedAt == 0) revert ExitNotRequested(account);
        uint256 availableAt = uint256(member.exitRequestedAt) + membershipExitCooldown;
        if (!archived && communityTime < availableAt) revert ExitCooldownNotFinished(availableAt);
        if (
            admins[account] || validators[account] || obligations[account] != 0
                || (votingModule != address(0) && ICommunityVotingModule(votingModule).hasExitBlockingObligation(account))
        ) {
            revert MembershipExitBlocked(account);
        }
        uint256 stake = member.membershipStake;
        member.active = false;
        member.joinedAt = 0;
        member.exitRequestedAt = 0;
        member.membershipStake = 0;
        treasury.releaseMembershipStake(account, stake);
        emit MembershipExited(account, stake);
    }

    /** @notice Adds an Admin after Hub quorum authorization. @param account Inactive non-validator account to promote. */
    function addAdmin(address account) external onlyHub {
        _addAdmin(account);
    }

    /** @notice Removes an Admin without permitting removal of the final Admin. @param account Active Admin to remove. */
    function removeAdmin(address account) external onlyHub {
        if (!admins[account]) revert RoleNotAssigned(account);
        if (adminCount == 1) revert CannotRemoveLastAdmin();
        admins[account] = false;
        adminRoleNonce[account] += 1;
        adminCount -= 1;
        emit AdminRemoved(account);
    }

    /** @notice Adds a validator after Hub eligibility and quorum checks. @param account Inactive non-Admin account to promote. */
    function addValidator(address account) external onlyHub {
        _addValidator(account);
    }

    /** @notice Removes a validator after Hub verifies the validator roster is unlocked. @param account Active validator to remove. */
    function removeValidator(address account) external onlyHub {
        if (!validators[account]) revert RoleNotAssigned(account);
        validators[account] = false;
        validatorCount -= 1;
        emit ValidatorRemoved(account);
    }

    /** @notice Adds an unresolved Member-proposal duty that blocks exit. @param account Active member whose obligation count increases. */
    function addObligation(address account) external onlyObligationAuthority {
        _activeMember(account);
        obligations[account] += 1;
    }

    /** @notice Clears one resolved Member-proposal duty. @param account Member whose obligation count decreases. */
    function clearObligation(address account) external onlyObligationAuthority {
        uint256 count = obligations[account];
        if (count == 0) revert MembershipExitBlocked(account);
        obligations[account] = count - 1;
    }

    /**
     * @notice Awards a point when a Member proposal reaches a successful outcome.
     * @param proposalId Proposal that earned the point.
     * @param account Member proposal author receiving the point.
     */
    function awardProposalPoint(uint256 proposalId, address account) external onlyObligationAuthority {
        CommunityTypes.MemberInfo storage member = members[account];
        member.proposalPoints += 1;
        emit ProposalPointAwarded(proposalId, account, member.proposalPoints);
        if (member.proposalPoints == validatorProposalPointsThreshold) {
            emit ValidatorEligibilityReached(account, member.proposalPoints);
        }
    }

    /* ========== INTERNAL INVARIANTS ========== */

    /** @dev Returns active member storage or reverts before any lifecycle mutation. */
    function _activeMember(address account) private view returns (CommunityTypes.MemberInfo storage member) {
        member = members[account];
        if (!member.active) revert NotCommunityMember(account);
    }

    /** @dev Grants the Admin role while enforcing role exclusivity. */
    function _addAdmin(address account) private {
        if (account == address(0)) revert ZeroAddress("admin");
        if (admins[account]) revert RoleAlreadyAssigned(account);
        if (validators[account] || members[account].active) revert AdminValidatorRoleConflict(account);
        admins[account] = true;
        adminRoleNonce[account] += 1;
        adminCount += 1;
        emit AdminAdded(account);
    }

    /** @dev Grants the validator role while enforcing exclusivity and roster cap. */
    function _addValidator(address account) private {
        if (account == address(0)) revert ZeroAddress("validator");
        if (validators[account]) revert RoleAlreadyAssigned(account);
        if (admins[account] || members[account].active) revert AdminValidatorRoleConflict(account);
        if (validatorCount == MAX_ACTIVE_VALIDATORS) revert InvalidCommunityConfig("validator cap");
        validators[account] = true;
        validatorCount += 1;
        emit ValidatorAdded(account);
    }
}
