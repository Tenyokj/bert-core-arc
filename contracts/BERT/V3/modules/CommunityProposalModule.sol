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

import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";
import {ICommunityMembershipModule} from "../interfaces/ICommunityMembershipModule.sol";
import {ICommunityProposalModule} from "../interfaces/ICommunityProposalModule.sol";
import {CommunityTypes} from "../libraries/CommunityTypes.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title CommunityProposalModule
 * @notice Owns V3.1 proposal creation and validator-review state for all four lanes.
 * @dev CommunityHub forwards the original caller and Community clock; voting
 *      state stays in CommunityVotingModule, keeping this module focused on
 *      proposal and bond lifecycles.
 *
 * @custom:version 1.0.1
 */
contract CommunityProposalModule is ICommunityProposalModule {
    /* ========== IMMUTABLE DEPENDENCIES AND CONFIGURATION ========== */

    /// @notice Hub that exclusively forwards proposal lifecycle calls.
    address public immutable hub;
    /// @notice Sole USDC custodian for Member proposal bonds and validator rewards.
    ICommunityTreasury public immutable treasury;
    /// @notice Membership/role registry used for authorship, validator, and exit checks.
    ICommunityMembershipModule public immutable membership;
    /// @notice USDC anti-spam bond required for every Member-origin proposal.
    uint256 public immutable proposalBondUSDC;
    /// @notice Number of validator approvals required to admit a Member proposal.
    uint256 public immutable validatorApprovalThreshold;
    /// @notice Pause-adjusted duration of a Member proposal validation window.
    uint256 public immutable validationWindow;
    /// @notice Pause-adjusted duration of one validator reward epoch.
    uint256 public immutable validatorRewardEpoch;
    /// @notice Basis-point share of validation cases a validator must complete to earn epoch rewards.
    uint256 public immutable validatorActiveThresholdBps;

    /* ========== PROPOSAL AND EPOCH STORAGE ========== */

    /// @notice Voting module authorized to mutate voting-related proposal fields.
    address public votingModule;
    /// @notice Monotonic identifier of the latest created proposal.
    uint256 public override proposalCount;
    /// @notice Number of Member proposals still awaiting validator review.
    uint256 public override pendingValidationProposalCount;
    /// @notice Identifier of the validator epoch receiving new Member review cases.
    uint256 public currentValidatorRewardEpochId;

    /// @dev Full proposal state by monotonic proposal ID.
    mapping(uint256 proposalId => CommunityTypes.Proposal proposal) private proposals;
    /// @dev Prevents a validator from deciding the same proposal twice.
    mapping(uint256 proposalId => mapping(address validator => bool cast)) public validatorDecisionCast;
    /// @dev Records the direction of each validator's one permitted decision.
    mapping(uint256 proposalId => mapping(address validator => bool approved)) public validatorApprovedProposal;
    /// @dev Epoch to which each Member proposal's validator work belongs.
    mapping(uint256 proposalId => uint256 epochId) private validationEpochIdByProposal;
    /// @dev Validator reward epoch accounting records.
    mapping(uint256 epochId => CommunityTypes.ValidatorRewardEpoch epoch) private validatorRewardEpochs;
    /// @dev Number of review cases completed by each validator during an epoch.
    mapping(uint256 epochId => mapping(address validator => uint256 count)) public validatorValidationCount;
    /// @dev Bounded list of validators that performed at least one review in an epoch.
    mapping(uint256 epochId => address[] validators) private validatorsByEpoch;
    /// @dev Prevents duplicate entries in validatorsByEpoch.
    mapping(uint256 epochId => mapping(address validator => bool recorded)) private validatorRecordedForEpoch;

    /* ========== EVENTS ========== */

    event ProposalCreated(uint256 indexed proposalId, address indexed creator, CommunityTypes.ProposalOrigin origin, CommunityTypes.ProposalMode mode);
    event ValidatorDecisionCast(uint256 indexed proposalId, address indexed validator, bool approved);
    event ProposalValidationFinalized(uint256 indexed proposalId, bool approved);
    event ValidatorRewardEpochRolled(uint256 indexed epochId, uint64 startTime, uint64 endTime);
    event VotingModuleConfigured(address indexed votingModule);

    /* ========== ACCESS CONTROL ========== */

    /// @notice Restricts user-facing lifecycle calls to the immutable Hub.
    modifier onlyHub() {
        if (msg.sender != hub) revert NotCommunityHub(msg.sender);
        _;
    }

    /// @notice Restricts vote totals and settlement state to the configured Voting module.
    modifier onlyVotingModule() {
        if (msg.sender != votingModule) revert NotCommunityHub(msg.sender);
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    /**
     * @notice Creates the isolated proposal and validator-review state for one Community.
     * @param hub_ Hub that routes all external proposal actions.
     * @param treasury_ Treasury that locks, returns, or slashes Member proposal bonds.
     * @param membership_ Membership module used for author and validator checks.
     * @param proposalBondUSDC_ Fixed USDC anti-spam bond for Member proposals.
     * @param validatorApprovalThreshold_ Approvals needed before a Member proposal can proceed.
     * @param validationWindow_ Community-clock deadline for one validator review.
     * @param validatorRewardEpoch_ Community-clock duration of a validator activity epoch.
     * @param validatorActiveThresholdBps_ Minimum share of available cases needed for epoch rewards.
     * @param initialCommunityTime_ Hub Community clock at module creation; opens epoch one.
     */
    constructor(
        address hub_,
        ICommunityTreasury treasury_,
        ICommunityMembershipModule membership_,
        uint256 proposalBondUSDC_,
        uint256 validatorApprovalThreshold_,
        uint256 validationWindow_,
        uint256 validatorRewardEpoch_,
        uint256 validatorActiveThresholdBps_,
        uint64 initialCommunityTime_
    ) {
        if (hub_ == address(0)) revert ZeroAddress("hub");
        if (address(treasury_) == address(0)) revert ZeroAddress("treasury");
        if (address(membership_) == address(0)) revert ZeroAddress("membership");
        if (
            proposalBondUSDC_ == 0 ||
            validatorApprovalThreshold_ == 0 ||
            validationWindow_ == 0 ||
            validatorRewardEpoch_ == 0 ||
            validatorActiveThresholdBps_ == 0 ||
            validatorActiveThresholdBps_ > CommunityTypes.MILESTONE_BPS_DENOMINATOR
        ) {
            revert InvalidCommunityConfig("proposal configuration");
        }
        hub = hub_;
        treasury = treasury_;
        membership = membership_;
        proposalBondUSDC = proposalBondUSDC_;
        validatorApprovalThreshold = validatorApprovalThreshold_;
        validationWindow = validationWindow_;
        validatorRewardEpoch = validatorRewardEpoch_;
        validatorActiveThresholdBps = validatorActiveThresholdBps_;
        currentValidatorRewardEpochId = 1;
        _openEpoch(1, initialCommunityTime_);
    }

    /* ========== CONFIGURATION AND VIEWS ========== */

    /**
     * @notice Binds the Voting module exactly once after module deployment.
     * @param votingModule_ Deployed CommunityVotingModule address.
     */
    function setVotingModule(address votingModule_) external onlyHub {
        if (votingModule != address(0)) revert CommunityV31ModulesAlreadyConfigured();
        if (votingModule_ == address(0) || votingModule_.code.length == 0) revert ZeroAddress("votingModule");
        votingModule = votingModule_;
        emit VotingModuleConfigured(votingModule_);
    }

    /** @notice Returns one proposal. @param proposalId Proposal identifier. @return Full proposal state. */
    function getProposal(uint256 proposalId) external view returns (CommunityTypes.Proposal memory) {
        _requireProposal(proposalId);
        return proposals[proposalId];
    }

    /** @notice Returns the validator epoch assigned to a Member proposal. @param proposalId Proposal identifier. @return Epoch identifier, or zero for Admin proposals. */
    function getValidationEpoch(uint256 proposalId) external view returns (uint256) {
        _requireProposal(proposalId);
        return validationEpochIdByProposal[proposalId];
    }

    /** @notice Returns validator reward epoch data. @param epochId Epoch identifier. @return Epoch activity and finalization record. */
    function getValidatorRewardEpoch(uint256 epochId) external view returns (CommunityTypes.ValidatorRewardEpoch memory) {
        CommunityTypes.ValidatorRewardEpoch memory epoch = validatorRewardEpochs[epochId];
        if (epoch.startTime == 0) revert ValidatorRewardEpochNotFound(epochId);
        return epoch;
    }

    /**
     * @notice Reports whether a validator completed the required share of epoch review cases.
     * @param epochId Finalized validator reward epoch.
     * @param validator Validator address to inspect.
     * @return True only when the epoch is finalized and activity meets the ceiling-rounded threshold.
     */
    function isValidatorActiveForEpoch(uint256 epochId, address validator) external view returns (bool) {
        CommunityTypes.ValidatorRewardEpoch storage epoch = validatorRewardEpochs[epochId];
        if (!epoch.finalized || epoch.availableValidationCases == 0) return false;
        return validatorValidationCount[epochId][validator] >= _requiredValidationCases(epoch.availableValidationCases);
    }

    /* ========== HUB-ROUTED PROPOSAL LIFECYCLE ========== */

    /** @notice Creates an Admin binary proposal ready for voting. @param creator Admin author. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @param communityTime Hub Community timestamp. @return New proposal identifier. */
    function createAdminBinary(address creator, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        external onlyHub returns (uint256)
    {
        return _createAdmin(creator, CommunityTypes.ProposalMode.Binary, title, description, metadataURI, communityTime);
    }

    /** @notice Creates an Admin slate proposal ready for round assignment. @param creator Admin author. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @param communityTime Hub Community timestamp. @return New proposal identifier. */
    function createAdminSlate(address creator, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        external onlyHub returns (uint256)
    {
        return _createAdmin(creator, CommunityTypes.ProposalMode.Slate, title, description, metadataURI, communityTime);
    }

    /** @notice Creates a bonded Member binary proposal awaiting validators. @param creator Active Member author. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @param communityTime Hub Community timestamp. @return New proposal identifier. */
    function createMemberBinary(address creator, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        external onlyHub returns (uint256)
    {
        return _createMember(creator, CommunityTypes.ProposalMode.Binary, title, description, metadataURI, communityTime);
    }

    /** @notice Creates a bonded Member slate proposal awaiting validators. @param creator Active Member author. @param title Proposal title. @param description Proposal body. @param metadataURI Off-chain metadata. @param communityTime Hub Community timestamp. @return New proposal identifier. */
    function createMemberSlate(address creator, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        external onlyHub returns (uint256)
    {
        return _createMember(creator, CommunityTypes.ProposalMode.Slate, title, description, metadataURI, communityTime);
    }

    /**
     * @notice Records one validator's approval or rejection and finalizes early when possible.
     * @param validator Validator whose Hub-routed decision is recorded.
     * @param proposalId Pending Member proposal.
     * @param approved True for approval, false for rejection.
     * @param communityTime Current pause-adjusted Community timestamp.
     */
    function castValidationDecision(address validator, uint256 proposalId, bool approved, uint64 communityTime) external onlyHub {
        if (!membership.isValidator(validator)) revert NotCommunityValidator(validator);
        CommunityTypes.Proposal storage proposal = _proposalForValidation(proposalId, communityTime);
        if (validatorDecisionCast[proposalId][validator]) revert ValidatorDecisionAlreadyCast(proposalId, validator);
        validatorDecisionCast[proposalId][validator] = true;
        validatorApprovedProposal[proposalId][validator] = approved;
        uint256 epochId = validationEpochIdByProposal[proposalId];
        validatorValidationCount[epochId][validator] += 1;
        if (!validatorRecordedForEpoch[epochId][validator]) {
            validatorRecordedForEpoch[epochId][validator] = true;
            validatorsByEpoch[epochId].push(validator);
        }
        if (approved) proposal.approvalCount += 1;
        else proposal.rejectionCount += 1;
        emit ValidatorDecisionCast(proposalId, validator, approved);

        if (proposal.approvalCount >= validatorApprovalThreshold) {
            _finalizeValidation(proposalId, true);
        } else {
            uint256 remaining = membership.validatorCount() - proposal.approvalCount - proposal.rejectionCount;
            if (proposal.approvalCount + remaining < validatorApprovalThreshold) _finalizeValidation(proposalId, false);
        }
    }

    /** @notice Finalizes a validation window after its deadline. @param proposalId Pending Member proposal. @param communityTime Current Community timestamp. */
    function finalizeExpiredValidation(uint256 proposalId, uint64 communityTime) external onlyHub {
        CommunityTypes.Proposal storage proposal = _proposalForValidation(proposalId, 0);
        if (communityTime < proposal.validationDeadline) revert ValidationStillOpen(proposalId, proposal.validationDeadline);
        _finalizeValidation(proposalId, proposal.approvalCount >= validatorApprovalThreshold);
    }

    /** @notice Rolls an elapsed validator epoch if necessary. @param communityTime Current Community timestamp. @return epochId Current/open epoch identifier. */
    function rollValidatorRewardEpoch(uint64 communityTime) external onlyHub returns (uint256 epochId) {
        _rollEpoch(communityTime);
        return currentValidatorRewardEpochId;
    }

    /**
     * @notice Finalizes a closed validator activity epoch and opens its Treasury reward claims.
     * @dev The bounded validator roster is recorded only for validators that reviewed a case,
     *      so finalization never scans the member set.
     * @param epochId Elapsed epoch identifier.
     * @param communityTime Current Community timestamp.
     */
    function finalizeValidatorRewardEpoch(uint256 epochId, uint64 communityTime) external onlyHub {
        CommunityTypes.ValidatorRewardEpoch storage epoch = validatorRewardEpochs[epochId];
        if (epoch.startTime == 0) revert ValidatorRewardEpochNotFound(epochId);
        if (epoch.finalized) revert ValidatorRewardEpochAlreadyFinalized(epochId);

        uint256 availableAt = uint256(epoch.endTime) + validationWindow;
        if (communityTime < availableAt) revert ValidationStillOpen(epochId, availableAt);

        uint256 activeValidatorCount = 0;
        if (epoch.availableValidationCases != 0) {
            uint256 requiredCases = _requiredValidationCases(epoch.availableValidationCases);
            address[] storage epochValidators = validatorsByEpoch[epochId];
            for (uint256 i; i < epochValidators.length; ++i) {
                if (validatorValidationCount[epochId][epochValidators[i]] >= requiredCases) {
                    activeValidatorCount += 1;
                }
            }
        }

        epoch.activeValidatorCount = activeValidatorCount;
        epoch.finalized = true;
        treasury.finalizeValidatorRewardEpoch(epochId, activeValidatorCount);
    }

    /* ========== VOTING-MODULE CALLBACKS ========== */

    /** @notice Marks an approved binary proposal as open. @param proposalId Binary proposal. @param communityTime Opening Community timestamp. @param duration Immutable voting duration in seconds. */
    function markBinaryVotingOpened(uint256 proposalId, uint64 communityTime, uint256 duration) external onlyVotingModule {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Binary || proposal.status != CommunityTypes.ProposalStatus.ApprovedForVoting) {
            revert InvalidProposalState(proposalId);
        }
        proposal.status = CommunityTypes.ProposalStatus.InVoting;
        proposal.votingStartedAt = communityTime;
        proposal.votingDeadline = communityTime + uint64(duration);
    }

    /** @notice Assigns an approved slate proposal to one round. @param proposalId Slate proposal. @param roundId New round identifier. */
    function markRoundAssigned(uint256 proposalId, uint256 roundId) external onlyVotingModule {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Slate || proposal.status != CommunityTypes.ProposalStatus.ApprovedForRound || proposal.assignedRoundId != 0) {
            revert InvalidRoundProposal(proposalId);
        }
        proposal.assignedRoundId = roundId;
        proposal.status = CommunityTypes.ProposalStatus.InRoundVoting;
    }

    /** @notice Adds settled-escrow weight to a binary proposal total. @param proposalId Binary proposal. @param choice YES or NO. @param amount USDC vote weight. */
    function recordBinaryVote(uint256 proposalId, CommunityTypes.VoteChoice choice, uint256 amount) external onlyVotingModule {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        if (choice == CommunityTypes.VoteChoice.Yes) proposal.yesVotes += amount;
        else proposal.noVotes += amount;
    }

    /** @notice Adds settled-escrow weight to a slate proposal total. @param proposalId Slate proposal. @param amount USDC vote weight. */
    function recordSlateVote(uint256 proposalId, uint256 amount) external onlyVotingModule {
        _proposal(proposalId).roundVotes += amount;
    }

    /** @notice Marks a binary proposal settled and resolves a Member bond/obligation. @param proposalId Binary proposal. @param accepted True when YES weight exceeded NO weight. */
    function settleBinaryProposal(uint256 proposalId, bool accepted) external onlyVotingModule {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Binary || proposal.status != CommunityTypes.ProposalStatus.InVoting) {
            revert InvalidProposalState(proposalId);
        }
        if (proposal.settled) revert ProposalAlreadySettled(proposalId);
        proposal.accepted = accepted;
        proposal.settled = true;
        proposal.status = CommunityTypes.ProposalStatus.Settled;
        _settleMemberProposal(proposalId, proposal, accepted);
    }

    /** @notice Marks a slate proposal settled and resolves a Member bond/obligation. @param proposalId Slate proposal. @param won True for the round winner. */
    function settleSlateProposal(uint256 proposalId, bool won) external onlyVotingModule {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Slate || proposal.status != CommunityTypes.ProposalStatus.InRoundVoting) {
            revert InvalidProposalState(proposalId);
        }
        if (proposal.settled) revert ProposalAlreadySettled(proposalId);
        proposal.accepted = won;
        proposal.settled = true;
        proposal.status = won ? CommunityTypes.ProposalStatus.WonRound : CommunityTypes.ProposalStatus.LostRound;
        _settleMemberProposal(proposalId, proposal, won);
    }

    /* ========== INTERNAL PROPOSAL AND EPOCH LOGIC ========== */

    /** @dev Returns a Member bond, clears exit obligation, and awards one point only for an accepted outcome. */
    function _settleMemberProposal(uint256 proposalId, CommunityTypes.Proposal storage proposal, bool accepted) private {
        if (proposal.origin == CommunityTypes.ProposalOrigin.Member) {
            treasury.returnProposalBond(proposalId, proposal.creator);
            membership.clearObligation(proposal.creator);
            if (accepted) membership.awardProposalPoint(proposalId, proposal.creator);
        }
    }

    /** @dev Creates an Admin proposal without validator review or bond custody. */
    function _createAdmin(address creator, CommunityTypes.ProposalMode mode, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        private returns (uint256 proposalId)
    {
        if (!membership.isAdmin(creator)) revert NotCommunityAdmin(creator);
        _requireText(title, description);
        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = creator;
        proposal.origin = CommunityTypes.ProposalOrigin.Admin;
        proposal.mode = mode;
        proposal.status = mode == CommunityTypes.ProposalMode.Binary ? CommunityTypes.ProposalStatus.ApprovedForVoting : CommunityTypes.ProposalStatus.ApprovedForRound;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = communityTime;
        emit ProposalCreated(proposalId, creator, proposal.origin, mode);
    }

    /** @dev Creates a Member proposal, rolls an epoch if needed, locks its bond, and blocks author exit. */
    function _createMember(address creator, CommunityTypes.ProposalMode mode, string calldata title, string calldata description, string calldata metadataURI, uint64 communityTime)
        private returns (uint256 proposalId)
    {
        if (!membership.isActiveMember(creator) || membership.hasPendingExit(creator)) revert NotCommunityMember(creator);
        _requireText(title, description);
        _rollEpoch(communityTime);
        proposalId = ++proposalCount;
        CommunityTypes.Proposal storage proposal = proposals[proposalId];
        proposal.creator = creator;
        proposal.origin = CommunityTypes.ProposalOrigin.Member;
        proposal.mode = mode;
        proposal.status = CommunityTypes.ProposalStatus.PendingValidation;
        proposal.title = title;
        proposal.description = description;
        proposal.metadataURI = metadataURI;
        proposal.createdAt = communityTime;
        proposal.validationDeadline = communityTime + uint64(validationWindow);
        proposal.bondAmount = proposalBondUSDC;
        validationEpochIdByProposal[proposalId] = currentValidatorRewardEpochId;
        validatorRewardEpochs[currentValidatorRewardEpochId].availableValidationCases += 1;
        pendingValidationProposalCount += 1;
        membership.addObligation(creator);
        treasury.depositProposalBond(proposalId, creator, proposalBondUSDC);
        emit ProposalCreated(proposalId, creator, proposal.origin, mode);
    }

    /** @dev Resolves review outcome: admit the proposal, or slash its bond and clear author obligation. */
    function _finalizeValidation(uint256 proposalId, bool approved) private {
        CommunityTypes.Proposal storage proposal = _proposal(proposalId);
        pendingValidationProposalCount -= 1;
        if (approved) {
            proposal.status = proposal.mode == CommunityTypes.ProposalMode.Binary ? CommunityTypes.ProposalStatus.ApprovedForVoting : CommunityTypes.ProposalStatus.ApprovedForRound;
        } else {
            proposal.status = CommunityTypes.ProposalStatus.RejectedByValidators;
            membership.clearObligation(proposal.creator);
            treasury.slashProposalBond(proposalId);
        }
        emit ProposalValidationFinalized(proposalId, approved);
    }

    /** @dev Loads a still-open Member validation record; a zero clock intentionally skips deadline checking for expiry finalization. */
    function _proposalForValidation(uint256 proposalId, uint64 communityTime) private view returns (CommunityTypes.Proposal storage proposal) {
        proposal = _proposal(proposalId);
        if (proposal.status != CommunityTypes.ProposalStatus.PendingValidation) revert InvalidProposalState(proposalId);
        if (communityTime != 0 && communityTime >= proposal.validationDeadline) revert ValidationWindowClosed(proposalId);
    }

    /** @dev Loads existing proposal storage. */
    function _proposal(uint256 proposalId) private view returns (CommunityTypes.Proposal storage proposal) {
        _requireProposal(proposalId);
        proposal = proposals[proposalId];
    }

    /** @dev Reverts unless `proposalId` is inside the monotonic proposal range. */
    function _requireProposal(uint256 proposalId) private view {
        if (proposalId == 0 || proposalId > proposalCount) revert CommunityProposalNotFound(proposalId);
    }

    /** @dev Opens a new validator epoch only after the current Community-clock epoch ends. */
    function _rollEpoch(uint64 communityTime) private {
        if (communityTime < validatorRewardEpochs[currentValidatorRewardEpochId].endTime) return;
        currentValidatorRewardEpochId += 1;
        _openEpoch(currentValidatorRewardEpochId, communityTime);
    }

    /** @dev Initializes one empty validator activity epoch. */
    function _openEpoch(uint256 epochId, uint64 startTime) private {
        uint64 endTime = startTime + uint64(validatorRewardEpoch);
        validatorRewardEpochs[epochId] = CommunityTypes.ValidatorRewardEpoch({
            startTime: startTime, endTime: endTime, availableValidationCases: 0, rewardAmount: 0, activeValidatorCount: 0, finalized: false
        });
        emit ValidatorRewardEpochRolled(epochId, startTime, endTime);
    }

    /** @dev Ceiling-rounds the configured validator activity percentage so partial work cannot round down to zero. */
    function _requiredValidationCases(uint256 availableCases) private view returns (uint256) {
        return (availableCases * validatorActiveThresholdBps + CommunityTypes.MILESTONE_BPS_DENOMINATOR - 1)
            / CommunityTypes.MILESTONE_BPS_DENOMINATOR;
    }

    /** @dev Rejects proposals without a meaningful title and description. */
    function _requireText(string calldata title, string calldata description) private pure {
        if (bytes(title).length == 0) revert ZeroLength("title");
        if (bytes(description).length == 0) revert ZeroLength("description");
    }
}
