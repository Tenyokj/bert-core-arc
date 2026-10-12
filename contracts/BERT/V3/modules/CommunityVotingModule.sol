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

import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";
import {ICommunityMembershipModule} from "../interfaces/ICommunityMembershipModule.sol";
import {ICommunityProposalModule} from "../interfaces/ICommunityProposalModule.sol";
import {ICommunityWinnerSnapshot} from "../interfaces/ICommunityWinnerSnapshot.sol";
import {ICommunityMilestoneManager} from "../interfaces/ICommunityMilestoneManager.sol";
import {ICommunityVotingModule} from "../interfaces/ICommunityVotingModule.sol";
import {CommunityTypes} from "../libraries/CommunityTypes.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title CommunityVotingModule
 * @notice Owns V3.1 binary and slate vote state, settlement, and winner snapshots.
 * @dev The Hub supplies the original actor and community-clock timestamp. This
 *      module rechecks roles, membership, proposal state, stake limits, and
 *      deadlines itself, so a facade cannot bypass governance invariants.
 *
 * @custom:version 1.0.1
 */
contract CommunityVotingModule is ICommunityVotingModule, ReentrancyGuard {
    /* ========== CONSTANTS ========== */

    /// @notice Maximum number of proposals in one slate round, keeping settlement bounded.
    uint256 public constant MAX_SLATE_PROPOSALS_PER_ROUND = 30;
    /// @notice Maximum USDC minor-unit commitment permitted from one wallet in one vote.
    uint256 public constant MAX_VOTE_STAKE_USDC = 10_000 * 1e6;
    /// @dev Denominator for basis-point configuration and calculations.
    uint256 private constant BPS_DENOMINATOR = 10_000;

    /* ========== IMMUTABLE DEPENDENCIES AND CONFIGURATION ========== */

    /// @notice Hub that exclusively routes mutating voting operations.
    address public immutable hub;
    /// @notice Treasury that locks and settles all binary/slate vote escrow.
    ICommunityTreasury public immutable treasury;
    /// @notice Membership module used for member/role/exit checks.
    ICommunityMembershipModule public immutable membership;
    /// @notice Proposal module used to validate and persist proposal transitions.
    ICommunityProposalModule public immutable proposals;
    /// @notice Minimum USDC vote amount for either voting lane.
    uint256 public immutable voteMinStakeUSDC;
    /// @notice Fixed Community-clock duration for binary voting.
    uint256 public immutable binaryVotingDuration;
    /// @notice Fixed Community-clock duration for slate rounds.
    uint256 public immutable roundVotingDuration;
    /// @notice Maximum-10% disclosed fee applied only to NO-side refunds.
    uint256 public immutable binaryRejectionFeeBps;
    /// @notice Member-origin successful-vote share reserved for validator reward epochs.
    uint256 public immutable validatorRewardShareBps;

    /* ========== VOTING AND LOCK STORAGE ========== */

    /// @notice Sealed winner-support snapshot module, configured exactly once.
    ICommunityWinnerSnapshot public winnerSnapshot;
    /// @notice Execution-plan manager, configured exactly once.
    ICommunityMilestoneManager public milestoneManager;
    /// @notice Monotonic slate-round identifier.
    uint256 public roundCount;
    /// @notice Number of currently open binary proposal votes; blocks archive.
    uint256 public activeBinaryProposalCount;
    /// @notice Number of currently open slate rounds; blocks archive.
    uint256 public activeSlateRoundCount;

    /// @dev Binary direction by proposal and voter; prevents duplicate binary votes.
    mapping(uint256 proposalId => mapping(address voter => CommunityTypes.VoteChoice choice)) private binaryChoice;
    /// @dev Binary escrow weight by proposal and voter.
    mapping(uint256 proposalId => mapping(address voter => uint256 stake)) private binaryStake;
    /// @dev Marks a settled binary vote lock as explicitly cleared.
    mapping(uint256 proposalId => mapping(address voter => bool cleared)) private binaryVoteLockCleared;
    /// @notice Number of wallets that voted in each binary proposal.
    mapping(uint256 proposalId => uint256 count) public binaryVoterCount;

    /// @dev Full slate-round records by monotonic round ID.
    mapping(uint256 roundId => CommunityTypes.CommunityRound round) private rounds;
    /// @dev Deterministic proposal order for each slate round and tie-breaking.
    mapping(uint256 roundId => uint256[] proposalIds) private proposalIdsByRound;
    /// @notice Whether a proposal is included in one specific slate round.
    mapping(uint256 roundId => mapping(uint256 proposalId => bool included)) public proposalIncludedInRound;
    /// @dev One selected proposal per voter per slate round.
    mapping(uint256 roundId => mapping(address voter => uint256 proposalId)) private selectedProposal;
    /// @dev Slate escrow weight by round and voter.
    mapping(uint256 roundId => mapping(address voter => uint256 stake)) private roundStake;
    /// @dev Marks a settled slate vote lock as explicitly cleared.
    mapping(uint256 roundId => mapping(address voter => bool cleared)) private roundVoteLockCleared;
    /// @notice Number of wallets that voted in each slate round.
    mapping(uint256 roundId => uint256 count) public roundVoterCount;
    /// @dev Number of vote locks still preventing each member's exit.
    mapping(address member => uint256 count) private unresolvedVoteLocks;

    /* ========== EVENTS ========== */

    event MilestoneModulesConfigured(address indexed winnerSnapshot, address indexed milestoneManager);
    event BinaryVotingOpened(uint256 indexed proposalId, uint256 votingDeadline);
    event BinaryVoteCast(uint256 indexed proposalId, address indexed voter, CommunityTypes.VoteChoice choice, uint256 amount);
    event BinaryProposalSettled(uint256 indexed proposalId, bool accepted, uint256 executionBudget);
    event SlateRoundCreated(uint256 indexed roundId, CommunityTypes.ProposalOrigin origin, uint256 votingDeadline);
    event SlateRoundVoteCast(uint256 indexed roundId, uint256 indexed proposalId, address indexed voter, uint256 amount);
    event SlateRoundSettled(uint256 indexed roundId, uint256 indexed winner, uint256 winningVotes, uint256 executionBudget);
    event VoteLockReleased(address indexed member, uint256 indexed scopeId, bool slateRound);

    /* ========== ACCESS CONTROL ========== */

    /// @notice Restricts every mutating operation to the immutable Hub.
    modifier onlyHub() {
        if (msg.sender != hub) revert NotCommunityHub(msg.sender);
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    /**
     * @notice Creates a Community's isolated binary/slate voting engine.
     * @param hub_ Hub that forwards all actor and Community-clock values.
     * @param treasury_ Treasury that locks and settles USDC vote escrow.
     * @param membership_ Membership module used for eligibility and exit checks.
     * @param proposals_ Proposal module used for all lifecycle transitions.
     * @param voteMinStakeUSDC_ Minimum USDC commitment accepted in one vote.
     * @param binaryVotingDuration_ Community-clock duration of binary votes.
     * @param roundVotingDuration_ Community-clock duration of slate rounds.
     * @param binaryRejectionFeeBps_ NO-side refund fee in basis points, capped at 10%.
     * @param validatorRewardShareBps_ Member-origin success share for validator epochs.
     */
    constructor(
        address hub_,
        ICommunityTreasury treasury_,
        ICommunityMembershipModule membership_,
        ICommunityProposalModule proposals_,
        uint256 voteMinStakeUSDC_,
        uint256 binaryVotingDuration_,
        uint256 roundVotingDuration_,
        uint256 binaryRejectionFeeBps_,
        uint256 validatorRewardShareBps_
    ) {
        if (hub_ == address(0)) revert ZeroAddress("hub");
        if (address(treasury_) == address(0)) revert ZeroAddress("treasury");
        if (address(membership_) == address(0)) revert ZeroAddress("membership");
        if (address(proposals_) == address(0)) revert ZeroAddress("proposals");
        if (voteMinStakeUSDC_ == 0 || voteMinStakeUSDC_ > MAX_VOTE_STAKE_USDC) revert InvalidCommunityConfig("voteMinStakeUSDC");
        if (binaryVotingDuration_ == 0 || roundVotingDuration_ == 0) revert InvalidCommunityConfig("votingDuration");
        if (binaryRejectionFeeBps_ > 1_000) revert RejectionFeeTooHigh(binaryRejectionFeeBps_, 1_000);
        // A 100% validator allocation would leave a successful member proposal
        // with a zero execution budget and make its milestone plan impossible.
        if (validatorRewardShareBps_ >= BPS_DENOMINATOR) revert InvalidCommunityConfig("validatorRewardShareBps");
        hub = hub_;
        treasury = treasury_;
        membership = membership_;
        proposals = proposals_;
        voteMinStakeUSDC = voteMinStakeUSDC_;
        binaryVotingDuration = binaryVotingDuration_;
        roundVotingDuration = roundVotingDuration_;
        binaryRejectionFeeBps = binaryRejectionFeeBps_;
        validatorRewardShareBps = validatorRewardShareBps_;
    }

    /* ========== CONFIGURATION AND VIEWS ========== */

    /**
     * @notice Binds plan dependencies exactly once after all modules are deployed.
     * @param winnerSnapshot_ Module that seals winning supporter weight.
     * @param milestoneManager_ Module that reserves and releases execution plans.
     */
    function setMilestoneModules(ICommunityWinnerSnapshot winnerSnapshot_, ICommunityMilestoneManager milestoneManager_)
        external
        onlyHub
    {
        if (address(winnerSnapshot) != address(0) || address(milestoneManager) != address(0)) {
            revert CommunityV31ModulesAlreadyConfigured();
        }
        if (address(winnerSnapshot_) == address(0) || address(milestoneManager_) == address(0)) {
            revert ZeroAddress("milestoneModule");
        }
        winnerSnapshot = winnerSnapshot_;
        milestoneManager = milestoneManager_;
        emit MilestoneModulesConfigured(address(winnerSnapshot_), address(milestoneManager_));
    }

    /** @notice Returns one binary vote. @param proposalId Binary proposal identifier. @param voter Voter address. @return choice Recorded direction. @return stake Escrowed USDC amount. */
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake)
    {
        return (binaryChoice[proposalId][voter], binaryStake[proposalId][voter]);
    }

    /** @notice Returns one slate vote. @param roundId Slate-round identifier. @param voter Voter address. @return proposalId Selected proposal or zero. @return stake Escrowed USDC amount. */
    function getSlateVote(uint256 roundId, address voter) external view returns (uint256 proposalId, uint256 stake) {
        return (selectedProposal[roundId][voter], roundStake[roundId][voter]);
    }

    /** @notice Returns a complete slate-round record. @param roundId Round identifier. @return Round lifecycle and settlement data. */
    function getRound(uint256 roundId) external view returns (CommunityTypes.CommunityRound memory) {
        _requireRound(roundId);
        return rounds[roundId];
    }

    /** @notice Returns deterministic slate proposal order. @param roundId Round identifier. @return Ordered proposal IDs. */
    function getRoundProposalIds(uint256 roundId) external view returns (uint256[] memory) {
        _requireRound(roundId);
        return proposalIdsByRound[roundId];
    }

    /** @notice Reports whether vote locks still block member exit. @param member Member address. @return True while any settled/active vote lock remains. */
    function hasExitBlockingObligation(address member) external view returns (bool) {
        return unresolvedVoteLocks[member] != 0;
    }

    /* ========== HUB-ROUTED BINARY VOTING ========== */

    /** @notice Opens an approved binary proposal. @param actor Admin requesting open. @param proposalId Approved binary proposal. @param communityTime Current Community timestamp. */
    function openBinaryVoting(address actor, uint256 proposalId, uint64 communityTime) external onlyHub {
        if (!membership.isAdmin(actor)) revert NotCommunityAdmin(actor);
        CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Binary || proposal.status != CommunityTypes.ProposalStatus.ApprovedForVoting) {
            revert InvalidProposalState(proposalId);
        }
        proposals.markBinaryVotingOpened(proposalId, communityTime, binaryVotingDuration);
        activeBinaryProposalCount += 1;
        emit BinaryVotingOpened(proposalId, uint256(communityTime) + binaryVotingDuration);
    }

    /**
     * @notice Locks USDC and records a single binary YES/NO vote.
     * @dev YES voters are recorded in the provisional winner snapshot. The
     *      snapshot is sealed only if YES wins at settlement.
     * @param voter Active member casting the vote.
     * @param proposalId Open binary proposal.
     * @param choice YES or NO; None is invalid.
     * @param amount USDC minor units committed to the selected direction.
     * @param communityTime Current Community timestamp used for deadline enforcement.
     */
    function castBinaryVote(address voter, uint256 proposalId, CommunityTypes.VoteChoice choice, uint256 amount, uint64 communityTime)
        external
        onlyHub
        nonReentrant
    {
        if (!membership.isActiveMember(voter) || membership.hasPendingExit(voter)) revert NotCommunityMember(voter);
        CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Binary || proposal.status != CommunityTypes.ProposalStatus.InVoting) {
            revert VotingNotOpen(proposalId);
        }
        if (communityTime >= proposal.votingDeadline) revert VotingWindowClosed(proposalId);
        if (proposal.creator == voter) revert ProposalAuthorCannotVote(proposalId, voter);
        if (choice == CommunityTypes.VoteChoice.None) revert InvalidVoteChoice();
        if (binaryChoice[proposalId][voter] != CommunityTypes.VoteChoice.None) revert BinaryVoteAlreadyCast(proposalId, voter);
        _requireStake(amount);

        treasury.depositVoteStake(proposalId, voter, amount);
        binaryChoice[proposalId][voter] = choice;
        binaryStake[proposalId][voter] = amount;
        binaryVoterCount[proposalId] += 1;
        unresolvedVoteLocks[voter] += 1;
        proposals.recordBinaryVote(proposalId, choice, amount);
        if (choice == CommunityTypes.VoteChoice.Yes) {
            winnerSnapshot.recordWinnerSupport(proposalId, voter, amount);
        }
        emit BinaryVoteCast(proposalId, voter, choice, amount);
    }

    /**
     * @notice Settles an elapsed binary vote and starts a plan if YES wins.
     * @dev YES escrow becomes execution capital. NO escrow routes to BERT's
     *      global reserve on a YES win; on NO/tie, eligible NO voters receive
     *      their disclosed pull refund through Treasury.
     * @param proposalId Expired binary proposal.
     * @param communityTime Current Community timestamp, which must reach deadline.
     */
    function settleBinaryProposal(uint256 proposalId, uint64 communityTime) external onlyHub nonReentrant {
        CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
        if (proposal.mode != CommunityTypes.ProposalMode.Binary || proposal.status != CommunityTypes.ProposalStatus.InVoting) {
            revert InvalidProposalState(proposalId);
        }
        if (communityTime < proposal.votingDeadline) revert VotingStillOpen(proposalId, proposal.votingDeadline);

        bool accepted = proposal.yesVotes > proposal.noVotes;
        uint256 executionBudget = 0;
        if (accepted) {
            uint256 rewardEpochId = proposal.origin == CommunityTypes.ProposalOrigin.Member
                ? proposals.getValidationEpoch(proposalId)
                : 0;
            treasury.settleBinaryYesWin(proposalId, proposal.yesVotes, proposal.noVotes, rewardEpochId);
            executionBudget = _executionBudget(proposal.yesVotes, proposal.origin, rewardEpochId);
            winnerSnapshot.sealWinnerSnapshot(proposalId, proposal.yesVotes);
        } else {
            treasury.settleBinaryNoWin(proposalId, proposal.yesVotes, proposal.noVotes, binaryRejectionFeeBps);
        }
        proposals.settleBinaryProposal(proposalId, accepted);
        activeBinaryProposalCount -= 1;
        if (accepted) milestoneManager.startExecutionPlan(proposalId, executionBudget, proposal.yesVotes, communityTime);
        emit BinaryProposalSettled(proposalId, accepted, executionBudget);
    }

    /* ========== HUB-ROUTED SLATE VOTING ========== */

    /** @notice Creates an Admin-origin slate round. @param actor Admin creator. @param proposalIds Approved Admin slate proposals. @param communityTime Current Community timestamp. @return New round identifier. */
    function createAdminSlateRound(address actor, uint256[] calldata proposalIds, uint64 communityTime)
        external
        onlyHub
        returns (uint256)
    {
        if (!membership.isAdmin(actor)) revert NotCommunityAdmin(actor);
        return _createSlateRound(CommunityTypes.ProposalOrigin.Admin, proposalIds, communityTime);
    }

    /** @notice Creates a Member-origin slate round. @param actor Admin creator. @param proposalIds Validator-approved Member slate proposals. @param communityTime Current Community timestamp. @return New round identifier. */
    function createMemberSlateRound(address actor, uint256[] calldata proposalIds, uint64 communityTime)
        external
        onlyHub
        returns (uint256)
    {
        if (!membership.isAdmin(actor)) revert NotCommunityAdmin(actor);
        return _createSlateRound(CommunityTypes.ProposalOrigin.Member, proposalIds, communityTime);
    }

    /** @notice Locks USDC and selects one proposal in an open slate round. @param voter Active member voter. @param roundId Open slate round. @param proposalId Included proposal selected by voter. @param amount USDC commitment. @param communityTime Current Community timestamp. */
    function castSlateRoundVote(address voter, uint256 roundId, uint256 proposalId, uint256 amount, uint64 communityTime)
        external
        onlyHub
        nonReentrant
    {
        if (!membership.isActiveMember(voter) || membership.hasPendingExit(voter)) revert NotCommunityMember(voter);
        _requireRound(roundId);
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        if (round.settled || communityTime >= round.endTime) revert VotingWindowClosed(roundId);
        if (!proposalIncludedInRound[roundId][proposalId]) revert InvalidRoundProposal(proposalId);
        CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
        if (proposal.creator == voter) revert ProposalAuthorCannotVote(proposalId, voter);
        if (selectedProposal[roundId][voter] != 0) revert RoundVoteAlreadyCast(roundId, voter);
        _requireStake(amount);

        treasury.depositRoundVoteStake(roundId, voter, amount);
        selectedProposal[roundId][voter] = proposalId;
        roundStake[roundId][voter] = amount;
        roundVoterCount[roundId] += 1;
        unresolvedVoteLocks[voter] += 1;
        round.totalVotes += amount;
        proposals.recordSlateVote(proposalId, amount);
        winnerSnapshot.recordWinnerSupport(proposalId, voter, amount);
        emit SlateRoundVoteCast(roundId, proposalId, voter, amount);
    }

    /**
     * @notice Settles an elapsed slate round, preserving deterministic first-ID tie-breaking.
     * @dev The whole round's escrow becomes execution capital, while the
     *      winner snapshot contains only voters who selected the winner.
     * @param roundId Expired slate round.
     * @param communityTime Current Community timestamp, which must reach deadline.
     */
    function settleSlateRound(uint256 roundId, uint64 communityTime) external onlyHub nonReentrant {
        _requireRound(roundId);
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        if (round.settled) revert ProposalAlreadySettled(roundId);
        if (communityTime < round.endTime) revert VotingStillOpen(roundId, round.endTime);

        uint256[] storage proposalIds = proposalIdsByRound[roundId];
        uint256 winningProposalId = proposalIds[0];
        uint256 winningVotes = proposals.getProposal(winningProposalId).roundVotes;
        for (uint256 i = 1; i < proposalIds.length; ++i) {
            uint256 candidateVotes = proposals.getProposal(proposalIds[i]).roundVotes;
            if (candidateVotes > winningVotes) {
                winningProposalId = proposalIds[i];
                winningVotes = candidateVotes;
            }
        }

        CommunityTypes.Proposal memory winner = proposals.getProposal(winningProposalId);
        uint256 rewardEpochId = round.origin == CommunityTypes.ProposalOrigin.Member
            ? proposals.getValidationEpoch(winningProposalId)
            : 0;
        treasury.settleSlateRound(roundId, round.totalVotes, rewardEpochId);
        round.winningProposalId = winningProposalId;
        round.winningVotes = winningVotes;
        round.settled = true;
        activeSlateRoundCount -= 1;

        for (uint256 i; i < proposalIds.length; ++i) {
            proposals.settleSlateProposal(proposalIds[i], proposalIds[i] == winningProposalId);
        }

        uint256 executionBudget = _executionBudget(round.totalVotes, winner.origin, rewardEpochId);
        if (winningVotes != 0) {
            winnerSnapshot.sealWinnerSnapshot(winningProposalId, winningVotes);
            milestoneManager.startExecutionPlan(winningProposalId, executionBudget, winningVotes, communityTime);
        }
        emit SlateRoundSettled(roundId, winningProposalId, winningVotes, executionBudget);
    }

    /* ========== EXIT-LOCK RELEASE ========== */

    /** @notice Clears a settled binary vote lock after any reviewer duty has resolved. @param voter Voter whose lock is cleared. @param proposalId Settled binary proposal. */
    function clearSettledBinaryVoteLock(address voter, uint256 proposalId) external onlyHub {
        CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
        if (!proposal.settled) revert ProposalNotSettled(proposalId);
        if (binaryChoice[proposalId][voter] == CommunityTypes.VoteChoice.None) revert VoteLockNotFound(proposalId, voter);
        if (binaryVoteLockCleared[proposalId][voter]) revert VoteLockAlreadyCleared(proposalId, voter);
        _requireReviewerLockReleased(proposalId, voter);
        binaryVoteLockCleared[proposalId][voter] = true;
        unresolvedVoteLocks[voter] -= 1;
        emit VoteLockReleased(voter, proposalId, false);
    }

    /** @notice Clears a settled slate vote lock after any reviewer duty has resolved. @param voter Voter whose lock is cleared. @param roundId Settled slate round. */
    function clearSettledRoundVoteLock(address voter, uint256 roundId) external onlyHub {
        _requireRound(roundId);
        CommunityTypes.CommunityRound memory round = rounds[roundId];
        if (!round.settled) revert ProposalNotSettled(roundId);
        uint256 selected = selectedProposal[roundId][voter];
        if (selected == 0) revert VoteLockNotFound(roundId, voter);
        if (roundVoteLockCleared[roundId][voter]) revert VoteLockAlreadyCleared(roundId, voter);
        if (selected == round.winningProposalId) _requireReviewerLockReleased(selected, voter);
        roundVoteLockCleared[roundId][voter] = true;
        unresolvedVoteLocks[voter] -= 1;
        emit VoteLockReleased(voter, roundId, true);
    }

    /* ========== INTERNAL SETTLEMENT HELPERS ========== */

    /** @dev Creates a bounded round, validates uniform origin/mode, and records deterministic proposal order. */
    function _createSlateRound(CommunityTypes.ProposalOrigin origin, uint256[] calldata proposalIds, uint64 communityTime)
        private
        returns (uint256 roundId)
    {
        if (proposalIds.length == 0 || proposalIds.length > MAX_SLATE_PROPOSALS_PER_ROUND) {
            revert InvalidCommunityConfig("slateProposalCount");
        }
        roundId = ++roundCount;
        CommunityTypes.CommunityRound storage round = rounds[roundId];
        round.origin = origin;
        round.startTime = communityTime;
        round.endTime = communityTime + uint64(roundVotingDuration);
        activeSlateRoundCount += 1;
        for (uint256 i; i < proposalIds.length; ++i) {
            uint256 proposalId = proposalIds[i];
            if (proposalIncludedInRound[roundId][proposalId]) revert InvalidRoundProposal(proposalId);
            CommunityTypes.Proposal memory proposal = proposals.getProposal(proposalId);
            if (
                proposal.origin != origin || proposal.mode != CommunityTypes.ProposalMode.Slate
                    || proposal.status != CommunityTypes.ProposalStatus.ApprovedForRound
            ) revert InvalidRoundProposal(proposalId);
            proposalIncludedInRound[roundId][proposalId] = true;
            proposalIdsByRound[roundId].push(proposalId);
            proposals.markRoundAssigned(proposalId, roundId);
        }
        emit SlateRoundCreated(roundId, origin, round.endTime);
    }

    /** @dev Deducts validator reward share only for a successful Member-origin proposal tied to an epoch. */
    function _executionBudget(uint256 grossStake, CommunityTypes.ProposalOrigin origin, uint256 rewardEpochId)
        private
        view
        returns (uint256)
    {
        if (origin == CommunityTypes.ProposalOrigin.Admin || rewardEpochId == 0) return grossStake;
        return grossStake - ((grossStake * validatorRewardShareBps) / BPS_DENOMINATOR);
    }

    /** @dev Keeps winning supporters locked until completion or their failed-plan refund claim. */
    function _requireReviewerLockReleased(uint256 proposalId, address voter) private view {
        if (winnerSnapshot.snapshotSealed(proposalId) && winnerSnapshot.milestoneVoterWeight(proposalId, voter) != 0) {
            if (!milestoneManager.canReleaseReviewerLock(proposalId, voter)) revert MembershipExitBlocked(voter);
        }
    }

    /** @dev Enforces immutable per-Community minimum and protocol-wide maximum vote stake. */
    function _requireStake(uint256 amount) private view {
        if (amount < voteMinStakeUSDC) revert VoteStakeTooLow(amount, voteMinStakeUSDC);
        if (amount > MAX_VOTE_STAKE_USDC) revert VoteAmountCapExceeded(amount, MAX_VOTE_STAKE_USDC);
    }

    /** @dev Reverts unless `roundId` belongs to a created slate round. */
    function _requireRound(uint256 roundId) private view {
        if (roundId == 0 || roundId > roundCount) revert CommunityRoundNotFound(roundId);
    }
}
