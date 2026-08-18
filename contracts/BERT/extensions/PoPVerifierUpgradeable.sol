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

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { RolesAwareUpgradeable } from "./Roles/RolesAwareUpgradeable.sol";
import { IHumanVerifier } from "../interfaces/IHumanVerifier.sol";
import "../utils/Errors.sol";

/**
 * @title PoPVerifierUpgradeable
 * @notice Stores backend-signed proof-of-personhood attestations for voting access
 * @dev Users submit an EIP-712 signature issued by a trusted backend after passing
 *      an external proof-of-personhood check. The resulting verified status is then
 *      consumed onchain by `VotingSystemUpgradeable`.
 *
 * @custom:version 1.0.0
 */
contract PoPVerifierUpgradeable is
    Initializable,
    EIP712Upgradeable,
    RolesAwareUpgradeable,
    IHumanVerifier
{
    /* ========== CONSTANTS ========== */

    /// @notice Human-readable EIP-712 domain name
    string public constant SIGNING_DOMAIN = "BERT PoP Verifier";

    /// @notice EIP-712 domain version
    string public constant SIGNATURE_VERSION = "1";

    /// @notice Type hash for verification payloads signed by the trusted backend
    bytes32 public constant VERIFICATION_TYPEHASH =
        keccak256(
            "Verification(address user,uint64 verifiedUntil,uint256 nonce,bytes32 provider,bytes32 credentialHash)"
        );

    /* ========== STATE ========== */

    /// @notice Backend signer authorized to attest proof-of-personhood results
    address public trustedSigner;

    /// @notice Timestamp until which an address remains verified
    mapping(address => uint64) public verifiedUntil;

    /// @notice Latest consumed nonce per address
    mapping(address => uint256) public latestNonce;

    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when a signed verification proof is recorded
     * @param user Wallet whose verification was recorded
     * @param verifiedUntilTimestamp Timestamp until which the verification remains valid
     * @param nonce Consumed nonce for the verification payload
     * @param provider Provider identifier, e.g. `keccak256("HUMAN_PASSPORT_STAMPS")`
     */
    event VerificationRecorded(
        address indexed user,
        uint64 verifiedUntilTimestamp,
        uint256 nonce,
        bytes32 provider
    );

    /**
     * @notice Emitted when the backend signer is updated
     * @param newSigner New trusted signer address
     */
    event TrustedSignerUpdated(address newSigner);

    /**
     * @notice Emitted when a user's onchain verification is revoked
     * @param user Wallet whose verification was revoked
     */
    event VerificationRevoked(address indexed user);

    /* ========== INITIALIZE ========== */

    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the PoP verifier contract
     * @param _rolesRegistry Address of the RolesRegistry contract
     * @param _trustedSigner Backend signer authorized to issue verification proofs
     * @custom:requires All addresses must be non-zero
     */
    function initialize(
        address _rolesRegistry,
        address _trustedSigner
    ) public initializer {
        if (_rolesRegistry == address(0)) revert ZeroAddress("rolesRegistry");
        if (_trustedSigner == address(0)) revert ZeroAddress("trustedSigner");

        __EIP712_init(SIGNING_DOMAIN, SIGNATURE_VERSION);
        __RolesAware_init(_rolesRegistry);

        trustedSigner = _trustedSigner;

        emit TrustedSignerUpdated(_trustedSigner);
    }

    /* ========== EXTERNAL FUNCTIONS ========== */

    /**
     * @notice Records a proof-of-personhood verification signed by the trusted backend
     * @dev The signed payload is bound to `msg.sender`, so proofs cannot be replayed
     *      by another wallet. Each new proof must advance the user's nonce.
     * @param verifiedUntil_ Expiration timestamp for the verification
     * @param nonce User-specific nonce signed by the backend
     * @param provider Provider identifier used for auditability
     * @param credentialHash Hash of offchain verification metadata
     * @param signature EIP-712 signature issued by `trustedSigner`
     * @custom:emits VerificationRecorded
     */
    function submitVerification(
        uint64 verifiedUntil_,
        uint256 nonce,
        bytes32 provider,
        bytes32 credentialHash,
        bytes calldata signature
    ) external {
        uint64 currentTime = uint64(block.timestamp);
        if (verifiedUntil_ <= currentTime) {
            revert VerifiedTimeExpired(msg.sender, currentTime, verifiedUntil_);
        }

        uint256 requiredNonce = latestNonce[msg.sender] + 1;
        if (nonce != requiredNonce) {
            revert InvalidNonce(nonce, requiredNonce);
        }

        bytes32 structHash = keccak256(
            abi.encode(
                VERIFICATION_TYPEHASH,
                msg.sender,
                verifiedUntil_,
                nonce,
                provider,
                credentialHash
            )
        );
        bytes32 digest = _hashTypedDataV4(structHash);
        address recoveredSigner = ECDSA.recover(digest, signature);

        if (recoveredSigner != trustedSigner) {
            revert InvalidSignatureSigner(recoveredSigner, trustedSigner);
        }

        verifiedUntil[msg.sender] = verifiedUntil_;
        latestNonce[msg.sender] = nonce;

        emit VerificationRecorded(msg.sender, verifiedUntil_, nonce, provider);
    }

    /**
     * @notice Revokes an address's recorded verification
     * @param user Wallet to revoke
     * @custom:emits VerificationRevoked
     * @custom:requires Caller must be admin
     */
    function revokeVerification(address user) external onlyAdmin {
        if (user == address(0)) revert ZeroAddress("user");

        delete verifiedUntil[user];

        emit VerificationRevoked(user);
    }

    /**
     * @notice Updates the trusted backend signer
     * @param newSigner New signer address
     * @custom:emits TrustedSignerUpdated
     * @custom:requires Caller must be admin
     */
    function setTrustedSigner(address newSigner) external onlyAdmin {
        if (newSigner == address(0)) revert ZeroAddress("newSigner");

        trustedSigner = newSigner;

        emit TrustedSignerUpdated(newSigner);
    }

    /* ========== VIEW FUNCTIONS ========== */

    /**
     * @notice Returns whether a wallet currently satisfies the verified-human requirement
     * @param account Wallet to check
     * @return bool True if the wallet's verification has not expired
     */
    function isVerifiedHuman(address account) public view returns (bool) {
        if (account == address(0)) {
            return false;
        }

        return verifiedUntil[account] >= block.timestamp;
    }

    /**
     * @notice Returns the current verification state for a wallet
     * @param account Wallet to query
     * @return verified Whether the wallet is currently verified
     * @return until Expiration timestamp of the current verification
     * @return nonce Latest consumed nonce for the wallet
     */
    function getVerification(address account)
        external
        view
        returns (bool verified, uint64 until, uint256 nonce)
    {
        verified = isVerifiedHuman(account);
        until = verifiedUntil[account];
        nonce = latestNonce[account];
    }

    /**
     * @notice Exposes the domain separator used for backend signatures
     * @return bytes32 Current EIP-712 domain separator
     */
    function domainSeparator() external view returns (bytes32) {
        return _domainSeparatorV4();
    }

    /* ========== UPGRADE SAFETY ========== */

    /// @dev Reserved storage slots for future upgrades
    uint256[50] private __gap;
}
