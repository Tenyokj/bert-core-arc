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

import {ICommunityMilestoneTreasury} from "../interfaces/ICommunityMilestoneTreasury.sol";
import {ICommunityMilestoneVoting} from "../interfaces/ICommunityMilestoneVoting.sol";
import {CommunityTypes} from "../libraries/CommunityTypes.sol";

/**
 * @title CommunityMilestoneManager
 * @notice V3.1 winner-supporter review flow for a Community execution budget.
 * @dev `planId == proposalId`. Voting snapshots eligible weights before this
 *      contract starts a plan, preventing later membership changes from changing quorum.
 * @custom:version 1.0.1
 */
contract CommunityMilestoneManager is ReentrancyGuard {
    // =============================================================
    //                     EXECUTION PARAMETERS
    // =============================================================

    /// @notice Delay before an executor may resubmit one corrected proof.
    uint64 public constant CORRECTION_COOLDOWN = 48 hours;
    /// @notice Additional review window granted after the first review misses quorum.
    uint64 public constant NO_QUORUM_GRACE = 2 days;
    /// @notice Number of post-initial-tranche milestones in every execution plan.
    uint8 public constant MILESTONE_COUNT = 2;

    // =============================================================
    //                    IMMUTABLE MODULE WIRING
    // =============================================================

    /// @notice Voting module authorized to begin a settled execution plan.
    address public immutable votingModule;
    /// @notice CommunityHub authorized to relay executor and reviewer actions.
    address public immutable hub;
    /// @notice Fixed Community treasury recipient that executes approved proposals.
    /// @dev The recipient is immutable so a proposal author cannot redirect plan funds.
    address public immutable executionRecipient;
    /// @notice Treasury ledger that reserves tranches and pays reviewer refunds.
    ICommunityMilestoneTreasury public immutable treasury;
    /// @notice Sealed winner snapshots used to determine reviewer eligibility and weight.
    ICommunityMilestoneVoting public immutable voting;
    /// @notice Duration of the ordinary milestone-review window in Community clock time.
    uint64 public immutable reviewDuration;
    /// @notice Maximum Community-clock time for the executor to submit each proof.
    uint64 public immutable proofDuration;

    // =============================================================
    //                      EXECUTION PLAN STORAGE
    // =============================================================

    /// @notice Per-proposal plan state, reserve accounting, and execution deadlines.
    mapping(uint256 planId => CommunityTypes.ExecutionPlan plan) private plans;
    /// @notice Review state for each plan milestone and proof attempt.
    mapping(uint256 planId => mapping(uint8 milestone => CommunityTypes.MilestoneReview review)) private reviews;
    /// @notice Latest review choice cast by a reviewer for a plan milestone.
    mapping(uint256 planId => mapping(uint8 milestone => mapping(address reviewer => CommunityTypes.MilestoneReviewChoice choice)))
        public reviewChoice;
    /// @notice Proof-attempt number on which each reviewer last voted.
    /// @dev This allows one vote for a corrected proof while preventing duplicate
    ///      votes during the same review attempt.
    mapping(uint256 planId => mapping(uint8 milestone => mapping(address reviewer => uint8 attempt)))
        private reviewAttemptByVoter;
    /// @notice Whether a winning supporter already claimed their failed-plan refund.
    mapping(uint256 planId => mapping(address supporter => bool claimed)) public refundClaimed;
    /// @notice Aggregate refunds paid for a failed plan, including rounding dust handling.
    mapping(uint256 planId => uint256 amount) public refundPaidByPlan;
    /// @notice Count of winning supporters that have claimed a failed-plan refund.
    mapping(uint256 planId => uint256 count) public refundClaimCountByPlan;
    /// @notice Number of plans that still block an eligible winning supporter's exit.
    uint256 public unresolvedPlanCount;

    // =============================================================
    //                            EVENTS
    // =============================================================

    /// @notice Emitted when voting reserves a winner budget and releases its initial tranche.
    /// @param planId Execution-plan ID, equal to the winning proposal ID.
    /// @param proposalId Proposal selected by its governance lane.
    /// @param budget Total Community treasury budget reserved for execution.
    /// @param initialTranche Twenty percent released to the execution recipient.
    event ExecutionPlanStarted(uint256 indexed planId, uint256 indexed proposalId, uint256 budget, uint256 initialTranche);
    /// @notice Emitted when the execution recipient submits proof for the active milestone.
    /// @param planId Execution-plan ID receiving a proof submission.
    /// @param milestone One-based milestone number being reviewed.
    /// @param evidenceHash Content hash of off-chain proof material.
    /// @param closesAt Community-clock deadline for reviewers to vote on this proof.
    event MilestoneProofSubmitted(uint256 indexed planId, uint8 indexed milestone, bytes32 evidenceHash, uint256 closesAt);
    /// @notice Emitted when an eligible winner supporter reviews a milestone proof.
    /// @param planId Execution-plan ID under review.
    /// @param milestone One-based milestone number under review.
    /// @param reviewer Winning supporter who cast the review.
    /// @param approved Whether the reviewer accepted the submitted proof.
    /// @param weight Immutable supporter weight counted for the review.
    event MilestoneReviewCast(uint256 indexed planId, uint8 indexed milestone, address indexed reviewer, bool approved, uint256 weight);
    /// @notice Emitted after a milestone passes quorum, approval, and unique-reviewer checks.
    /// @param planId Execution-plan ID whose milestone passed.
    /// @param milestone One-based milestone number that passed.
    /// @param releasedAmount Amount released to the fixed execution recipient.
    event MilestoneApproved(uint256 indexed planId, uint8 indexed milestone, uint256 releasedAmount);
    /// @notice Emitted after the first rejected proof opens a correction path.
    /// @param planId Execution-plan ID entering correction cooldown.
    /// @param milestone One-based milestone requiring corrected proof.
    /// @param availableAt Community-clock time at which resubmission becomes available.
    event MilestoneCorrectionOpened(uint256 indexed planId, uint8 indexed milestone, uint256 availableAt);
    /// @notice Emitted when an under-quorum review receives its final grace window.
    /// @param planId Execution-plan ID receiving a grace review.
    /// @param milestone One-based milestone receiving the grace review.
    /// @param closesAt Community-clock deadline for the grace review.
    event MilestoneGraceOpened(uint256 indexed planId, uint8 indexed milestone, uint256 closesAt);
    /// @notice Emitted when a plan fails and its unreleased reserve becomes refundable.
    /// @param planId Failed execution-plan ID.
    /// @param refundableAmount Unreleased budget available pro rata to winning supporters.
    event ExecutionPlanFailed(uint256 indexed planId, uint256 refundableAmount);
    /// @notice Emitted after the final milestone releases the remaining plan reserve.
    /// @param planId Execution-plan ID that completed successfully.
    event ExecutionPlanCompleted(uint256 indexed planId);
    /// @notice Emitted after a winning supporter withdraws their failed-plan refund.
    /// @param planId Failed execution-plan ID.
    /// @param supporter Winning supporter receiving the refund.
    /// @param amount Pro-rata refund amount, including final-claimer rounding dust.
    event ExecutionRefundClaimed(uint256 indexed planId, address indexed supporter, uint256 amount);

    // =============================================================
    //                        ACCESS CONTROL
    // =============================================================

    /// @notice Restricts plan creation to the Community voting module.
    modifier onlyVotingModule() {
        require(msg.sender == votingModule, "only voting module");
        _;
    }

    /// @notice Restricts user-originated execution actions to the CommunityHub relay.
    modifier onlyHub() {
        require(msg.sender == hub, "only hub");
        _;
    }

    // =============================================================
    //                          CONSTRUCTOR
    // =============================================================

    /**
     * @notice Creates a milestone manager for exactly one Community.
     * @param hub_ CommunityHub that checks caller permissions and forwards actions.
     * @param votingModule_ CommunityVotingModule that settles winners and starts plans.
     * @param executionRecipient_ Immutable treasury recipient responsible for delivery.
     * @param treasury_ Treasury module holding Community reserves and refunds.
     * @param voting_ Winner snapshot module supplying immutable reviewer weights.
     * @param reviewDuration_ Review duration constrained to one through fourteen days.
     * @param proofDuration_ Deadline allowed for each proof submission.
     */
    constructor(
        address hub_,
        address votingModule_,
        address executionRecipient_,
        ICommunityMilestoneTreasury treasury_,
        ICommunityMilestoneVoting voting_,
        uint64 reviewDuration_,
        uint64 proofDuration_
    ) {
        require(hub_ != address(0) && votingModule_ != address(0) && executionRecipient_ != address(0), "zero address");
        require(address(treasury_) != address(0) && address(voting_) != address(0), "zero module");
        require(reviewDuration_ >= 1 days && reviewDuration_ <= 14 days, "review duration");
        require(proofDuration_ != 0, "proof duration");
        hub = hub_;
        votingModule = votingModule_;
        executionRecipient = executionRecipient_;
        treasury = treasury_;
        voting = voting_;
        reviewDuration = reviewDuration_;
        proofDuration = proofDuration_;
    }

    // =============================================================
    //                         STATE VIEWS
    // =============================================================

    /**
     * @notice Returns all execution-plan accounting and lifecycle state.
     * @param planId Winning proposal/execution-plan ID to inspect.
     * @return plan Stored plan data; a zero-valued struct means no plan exists.
     */
    function getPlan(uint256 planId) external view returns (CommunityTypes.ExecutionPlan memory) {
        return plans[planId];
    }

    /**
     * @notice Returns the latest proof-review state for one plan milestone.
     * @param planId Execution-plan ID to inspect.
     * @param milestone One-based milestone number to inspect.
     * @return review Stored review data, including weights, deadlines, and proof attempts.
     */
    function getReview(uint256 planId, uint8 milestone)
        external
        view
        returns (CommunityTypes.MilestoneReview memory)
    {
        return reviews[planId][milestone];
    }

    // =============================================================
    //                    EXECUTION PLAN LIFECYCLE
    // =============================================================

    /**
     * @notice Reserves a winning proposal budget and releases its initial twenty percent.
     * @dev Called only after the voting module sealed the winner snapshot. The
     *      remaining budget stays reserved in the treasury until milestone
     *      approval or failed-plan refund claims resolve it.
     * @param proposalId Winning proposal ID, reused as the execution-plan ID.
     * @param budget Full Community treasury amount approved for this proposal.
     * @param eligibleSupportWeight Immutable aggregate weight eligible to review.
     * @param communityTime Pausable Community clock time used to start the proof deadline.
     */
    function startExecutionPlan(uint256 proposalId, uint256 budget, uint256 eligibleSupportWeight, uint64 communityTime)
        external
        onlyVotingModule
        nonReentrant
    {
        require(proposalId != 0 && budget != 0 && eligibleSupportWeight != 0, "invalid plan");
        require(plans[proposalId].status == CommunityTypes.ExecutionPlanStatus.None, "plan exists");
        uint256 initialTranche = (budget * 2_000) / CommunityTypes.MILESTONE_BPS_DENOMINATOR;
        plans[proposalId] = CommunityTypes.ExecutionPlan({
            proposalId: proposalId,
            totalBudget: budget,
            eligibleSupportWeight: eligibleSupportWeight,
            releasedAmount: initialTranche,
            refundableAmount: 0,
            proofDeadline: communityTime + proofDuration,
            currentMilestone: 1,
            status: CommunityTypes.ExecutionPlanStatus.AwaitingProof
        });
        unresolvedPlanCount += 1;
        treasury.reserveExecutionPlan(proposalId, budget);
        treasury.releaseExecutionTranche(proposalId, executionRecipient, initialTranche);
        emit ExecutionPlanStarted(proposalId, proposalId, budget, initialTranche);
    }

    /**
     * @notice Opens review for the active milestone using an off-chain evidence hash.
     * @dev The Hub supplies the original caller as `executor`; only the immutable
     *      Community execution recipient can submit proof. Corrected proof
     *      submissions create a new review attempt with fresh vote eligibility.
     * @param executor Original external caller forwarded by CommunityHub.
     * @param planId Execution-plan ID receiving the proof.
     * @param evidenceHash Content hash that locates the proof bundle off chain.
     * @param communityTime Current pausable Community clock time.
     */
    function submitMilestoneProof(address executor, uint256 planId, bytes32 evidenceHash, uint64 communityTime) external onlyHub {
        require(executor == executionRecipient, "only execution recipient");
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(plan.status == CommunityTypes.ExecutionPlanStatus.AwaitingProof, "proof unavailable");
        require(communityTime <= plan.proofDeadline && evidenceHash != bytes32(0), "invalid proof");
        CommunityTypes.MilestoneReview storage review = reviews[planId][plan.currentMilestone];
        // A supporter gets one vote for each submitted proof, including a corrected proof.
        review.proofAttempts += 1;
        review.openedAt = communityTime;
        review.closesAt = communityTime + reviewDuration;
        review.evidenceHash = evidenceHash;
        plan.status = CommunityTypes.ExecutionPlanStatus.Reviewing;
        emit MilestoneProofSubmitted(planId, plan.currentMilestone, evidenceHash, review.closesAt);
    }

    /**
     * @notice Records an eligible winning supporter's review for the active proof attempt.
     * @dev A reviewer may vote once per proof attempt. Only snapshot supporters
     *      of the winning proposal have nonzero weight; author/executor exclusion
     *      is enforced by the voting module before snapshot recording.
     * @param reviewer Original Community member forwarded by CommunityHub.
     * @param planId Execution-plan ID under review.
     * @param approved Whether the reviewer accepts the submitted evidence.
     * @param communityTime Current pausable Community clock time.
     */
    function castMilestoneReview(address reviewer, uint256 planId, bool approved, uint64 communityTime) external onlyHub {
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(
            plan.status == CommunityTypes.ExecutionPlanStatus.Reviewing
                || plan.status == CommunityTypes.ExecutionPlanStatus.GraceReview,
            "review unavailable"
        );
        CommunityTypes.MilestoneReview storage review = reviews[planId][plan.currentMilestone];
        require(communityTime < review.closesAt, "review closed");
        uint8 currentAttempt = review.proofAttempts;
        require(reviewAttemptByVoter[planId][plan.currentMilestone][reviewer] != currentAttempt, "already reviewed");
        uint256 weight = voting.milestoneVoterWeight(planId, reviewer);
        require(weight != 0, "not winning supporter");
        reviewChoice[planId][plan.currentMilestone][reviewer] = approved
            ? CommunityTypes.MilestoneReviewChoice.Approve
            : CommunityTypes.MilestoneReviewChoice.Reject;
        reviewAttemptByVoter[planId][plan.currentMilestone][reviewer] = currentAttempt;
        review.participatingAddresses += 1;
        if (approved) {
            review.approvingWeight += weight;
            review.approvingAddresses += 1;
        } else review.rejectingWeight += weight;
        emit MilestoneReviewCast(planId, plan.currentMilestone, reviewer, approved, weight);
    }

    /**
     * @notice Resolves an expired review as approved, correction-required, grace, or failed.
     * @dev A review requires: (1) the milestone quorum over the sealed winning
     *      support weight, (2) a two-thirds weighted approval among participating
     *      reviewers, and (3) the minimum count of distinct approving wallets.
     *      An under-quorum initial review receives one grace window; a rejected
     *      first proof receives one correction opportunity; all terminal failures
     *      seed refunds from the unreleased treasury reserve.
     * @param planId Execution-plan ID whose active review is ready to resolve.
     * @param communityTime Current pausable Community clock time.
     */
    function finalizeMilestoneReview(uint256 planId, uint64 communityTime) external onlyHub nonReentrant {
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(
            plan.status == CommunityTypes.ExecutionPlanStatus.Reviewing
                || plan.status == CommunityTypes.ExecutionPlanStatus.GraceReview,
            "review unavailable"
        );
        CommunityTypes.MilestoneReview storage review = reviews[planId][plan.currentMilestone];
        require(communityTime >= review.closesAt, "review open");
        uint256 participatingWeight = review.approvingWeight + review.rejectingWeight;
        uint256 quorum = _ceilDiv(
            plan.eligibleSupportWeight * CommunityTypes.MILESTONE_QUORUM_BPS,
            CommunityTypes.MILESTONE_BPS_DENOMINATOR
        );
        if (participatingWeight < quorum) {
            if (plan.status == CommunityTypes.ExecutionPlanStatus.Reviewing) {
                plan.status = CommunityTypes.ExecutionPlanStatus.GraceReview;
                review.closesAt = communityTime + NO_QUORUM_GRACE;
                emit MilestoneGraceOpened(planId, plan.currentMilestone, review.closesAt);
            } else _failPlan(planId);
            return;
        }
        uint256 minApprovers = (voting.milestoneVoterCount(planId) * CommunityTypes.MILESTONE_MIN_APPROVER_SHARE_BPS
            + CommunityTypes.MILESTONE_BPS_DENOMINATOR - 1) / CommunityTypes.MILESTONE_BPS_DENOMINATOR;
        if (minApprovers < CommunityTypes.MILESTONE_MIN_UNIQUE_APPROVERS) minApprovers = CommunityTypes.MILESTONE_MIN_UNIQUE_APPROVERS;
        bool passed = review.approvingWeight * CommunityTypes.MILESTONE_BPS_DENOMINATOR
            >= participatingWeight * CommunityTypes.MILESTONE_APPROVAL_BPS && review.approvingAddresses >= minApprovers;
        if (!passed) {
            if (review.proofAttempts == 1) {
                review.correctionAvailableAt = communityTime + CORRECTION_COOLDOWN;
                plan.status = CommunityTypes.ExecutionPlanStatus.CorrectionCooldown;
                emit MilestoneCorrectionOpened(planId, plan.currentMilestone, review.correctionAvailableAt);
            } else _failPlan(planId);
            return;
        }
        uint256 tranche = plan.currentMilestone == 1
            ? (plan.totalBudget * 4_000) / CommunityTypes.MILESTONE_BPS_DENOMINATOR
            : plan.totalBudget - plan.releasedAmount;
        uint8 settledMilestone = plan.currentMilestone;
        plan.releasedAmount += tranche;
        if (settledMilestone == MILESTONE_COUNT) {
            plan.status = CommunityTypes.ExecutionPlanStatus.Completed;
            unresolvedPlanCount -= 1;
        } else {
            plan.currentMilestone = 2;
            plan.proofDeadline = communityTime + proofDuration;
            plan.status = CommunityTypes.ExecutionPlanStatus.AwaitingProof;
        }
        treasury.releaseExecutionTranche(planId, executionRecipient, tranche);
        emit MilestoneApproved(planId, settledMilestone, tranche);
        if (settledMilestone == MILESTONE_COUNT) emit ExecutionPlanCompleted(planId);
    }

    /**
     * @notice Reopens a rejected first milestone for exactly one corrected proof.
     * @dev Previous review tallies are reset, while the proof-attempt counter is
     *      retained so each supporter may cast one fresh vote on the correction.
     * @param executor Original external caller forwarded by CommunityHub.
     * @param planId Execution-plan ID leaving correction cooldown.
     * @param communityTime Current pausable Community clock time.
     */
    function reopenAfterCorrection(address executor, uint256 planId, uint64 communityTime) external onlyHub {
        require(executor == executionRecipient, "only execution recipient");
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(plan.status == CommunityTypes.ExecutionPlanStatus.CorrectionCooldown, "correction unavailable");
        CommunityTypes.MilestoneReview storage review = reviews[planId][plan.currentMilestone];
        require(communityTime >= review.correctionAvailableAt, "cooldown active");
        review.openedAt = 0;
        review.closesAt = 0;
        review.correctionAvailableAt = 0;
        review.approvingWeight = 0;
        review.rejectingWeight = 0;
        review.approvingAddresses = 0;
        review.participatingAddresses = 0;
        review.evidenceHash = bytes32(0);
        plan.status = CommunityTypes.ExecutionPlanStatus.AwaitingProof;
    }

    /**
     * @notice Fails a plan whose execution recipient missed the active proof deadline.
     * @param planId Execution-plan ID to fail for proof-submission inactivity.
     * @param communityTime Current pausable Community clock time.
     */
    function failExpiredPlan(uint256 planId, uint64 communityTime) external onlyHub {
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(plan.status == CommunityTypes.ExecutionPlanStatus.AwaitingProof && communityTime > plan.proofDeadline, "plan active");
        _failPlan(planId);
    }

    /**
     * @notice Pays a failed plan's unreleased budget back to a winning supporter.
     * @dev Refunds are proportional to immutable winner support weight. The final
     *      claimer receives any integer-division dust, ensuring the full reserve
     *      is distributable without leaving stranded treasury accounting.
     * @param supporter Original Community member forwarded by CommunityHub.
     * @param planId Failed execution-plan ID from which to claim.
     */
    function claimFailedPlanRefund(address supporter, uint256 planId) external onlyHub nonReentrant {
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        require(plan.status == CommunityTypes.ExecutionPlanStatus.Failed && !refundClaimed[planId][supporter], "refund unavailable");
        uint256 weight = voting.milestoneVoterWeight(planId, supporter);
        require(weight != 0, "not winning supporter");
        refundClaimed[planId][supporter] = true;
        uint256 nextClaimCount = refundClaimCountByPlan[planId] + 1;
        uint256 supporterCount = voting.milestoneVoterCount(planId);
        uint256 amount = nextClaimCount == supporterCount
            ? plan.refundableAmount - refundPaidByPlan[planId]
            : (plan.refundableAmount * weight) / plan.eligibleSupportWeight;
        refundClaimCountByPlan[planId] = nextClaimCount;
        refundPaidByPlan[planId] += amount;
        treasury.claimExecutionPlanRefund(planId, supporter, amount);
        emit ExecutionRefundClaimed(planId, supporter, amount);
    }

    // =============================================================
    //                    MEMBERSHIP LOCK VIEWS
    // =============================================================

    /**
     * @notice Reports whether one winning supporter may release their exit lock.
     * @dev Completion releases every reviewer lock. On failure, each supporter
     *      remains locked only until they personally claim their pro-rata refund.
     * @param planId Execution-plan ID that created the reviewer exit lock.
     * @param supporter Winning supporter whose lock is being checked.
     * @return releasable Whether the voting module may clear this plan's lock.
     */
    function canReleaseReviewerLock(uint256 planId, address supporter) external view returns (bool) {
        CommunityTypes.ExecutionPlanStatus status = plans[planId].status;
        if (status == CommunityTypes.ExecutionPlanStatus.Completed) return true;
        return status == CommunityTypes.ExecutionPlanStatus.Failed && refundClaimed[planId][supporter];
    }

    // =============================================================
    //                       INTERNAL HELPERS
    // =============================================================

    /**
     * @notice Marks a plan failed and converts every unreleased tranche into refunds.
     * @param planId Execution-plan ID that reached a terminal failure condition.
     */
    function _failPlan(uint256 planId) private {
        CommunityTypes.ExecutionPlan storage plan = plans[planId];
        uint256 unreleased = plan.totalBudget - plan.releasedAmount;
        plan.refundableAmount = unreleased;
        plan.status = CommunityTypes.ExecutionPlanStatus.Failed;
        unresolvedPlanCount -= 1;
        treasury.seedExecutionPlanRefund(planId, unreleased);
        emit ExecutionPlanFailed(planId, unreleased);
    }

    /**
     * @notice Divides two unsigned integers and rounds any nonzero remainder up.
     * @param numerator Value to divide.
     * @param denominator Nonzero divisor.
     * @return quotient Ceiling of `numerator / denominator`.
     */
    function _ceilDiv(uint256 numerator, uint256 denominator) private pure returns (uint256) {
        return numerator == 0 ? 0 : ((numerator - 1) / denominator) + 1;
    }
}
