#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#-- Date:   03 September 2016
#
#
#-- Description:
#
#   This script implements D_Criterion against a set of defimed orbital elements.
#
#   DCalc:  Calculates D criterion for multiple orbits in a data frame against a
#           a single reference orbit
#
#   DCalc2: Calculates D criterion two single orbits
#
#
#   DCalc Parameters:
#
#     mu      - dataframe containing orbits to be evaluated (UFO Orbit output)
#     e2      - eccentricity f the reference orbit
#     q2      - perihelion distance of the reference orbit
#     incl2   - inclination of the refernce orbit (in degrees)
#     node2   - longitude of ascending node
#     peri2   - argument of perihelion of the reference orbit (im degrees)
#     D_type  - type of D_criterion analysis.
#
#   DCalc2 Parameters:
#
#     e1      - eccentricity of the test orbit
#     q1      - perihelion distance of the test orbit
#     incl1   - inclination of the test orbit (in degrees)
#     node1   - longitude of ascending node of the test orbit
#     peri1   - argument of perihelion of the test orbit (im degrees)
#     e2      - eccentricity of the reference orbit
#     q2      - perihelion distance of the reference orbit
#     incl2   - inclination of the refernce orbit (in degrees)
#     node2   - longitude of ascending node
#     peri2   - argument of perihelion of the reference orbit (im degrees)
#     D_type  - type of D_criterion analysis.
#
#
#   D_type values are:
#
#     - "DSH"(Southwood and Hawkins)
#     - "DD" (Drummond)
#     - "DH" (variant by Jopek)
#
#   Returns mu with added column with calculated D_Value for each row
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Version History
#
#   Vers  Date        Notes
#   ----  ----        -----
#   1.0   20/09/2016  First release
#
#
#=============================================================================

# Define SECANT function

sec <- function(x) {
  return(1/cos(x))
}

DCalc <- function(mu, e2, q2, incl2, node2, peri2, D_Type="DD") {

  Debug = FALSE
  
  # If it does not already exist, add D_Value column to recieve results
  if ( !("D_Value" %in% colnames(mu)) ) {
    mu["D_Value"] <- NA
  }
  
  # Convert degrees to Radians   
  i2 <- incl2 * pi / 180
  n2 <- node2 * pi / 180
  p2 <- peri2 * pi / 180
  
  i1 <- mu$X_incl * pi / 180
  n1 <- mu$X_node * pi / 180    
  p1 <- mu$X_peri * pi / 180
  
  q1 <- mu$X_q
  e1 <- mu$X_e
  I21 <- acos(cos(i1) * cos(i2) + sin(i1) * sin(i2) * cos(n2 - n1) )
  
  #ADIFF <- ifelse((abs(n1-n2) <= pi),abs(n1-n2), abs(abs(n1-n2) - 2 * pi))
  ADIFF <- abs(n1-n2)
  II21a  <- p2 - p1 + 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21b  <- p2 - p1 - 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21   <- ifelse((ADIFF <= pi),II21a,II21b) 
  if (D_Type == "DD") {
    B1 <- asin(sin(i1) * sin(p1))
    B2 <- asin(sin(i2) * sin(p2))
    G1 <- ifelse((cos(p1) >= 0), n1 + atan(cos(i1) * tan(p1)), pi + n1 + atan(cos(i1) * tan(p1)))
    G2 <- ifelse((cos(p2) >= 0), n2 + atan(cos(i2) * tan(p2)), pi + n2 + atan(cos(i2) * tan(p2)))
    Theta <- acos( sin(B1) * sin(B2) + cos(B1) * cos(B2) * cos(G2-G1) )
    mu$D_Value  = sqrt( ((q2 - q1)/(q2 + q1))**2 + ((e2 - e1)/(e2 + e1))**2 + (I21 / pi)**2 +((e2+e1)/2)**2 * (Theta/pi)**2)
  }
  
  if (D_Type == "DSH") {	
    mu$D_Value = sqrt ( (q2 - q1)**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + ( (e2 + e1)/2 * 2 * sin(II21/2) )**2 )
  }
  
  if (D_Type == "DH") {	
    mu$D_Value  = sqrt ( ((q2 - q1)/(q2 + q1))**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + (((e2 + e1) / 2) * 2 * sin(II21/2) )**2 )		
  }
  
  if (Debug == TRUE) {
    n = 10
    cat("N:     ",mu$X__[1:n],"\n")
    cat("e:     ",e1[1:n],"\n","e2:    ",e2,"\n")
    cat("i:     ",i1[1:n],"\n","i2:    ",i2,"\n")
    cat("p:     ",p1[1:n],"\n","p2:    ",p2,"\n")
    cat("n:     ",n1[1:n],"\n","n2:    ",n2,"\n")
    cat("q:     ",q1[1:n],"\n","q2:    ",q2,"\n")
    cat("I21:   ",I21[1:n],"\n")
    if (D_Type != "DD") {
      cat("ADIFF: ",ADIFF[1:n],"\n")
      cat("II21:  ",II21[1:n],"\n")
      } else {
      cat("B1:    ",B1[1:n],"\n","B2:    ",B2,"\n")
      cat("G1:    ",G1[1:n],"\n","G2:    ",G2,"\n")
      cat("Theta: ",Theta[1:n],"\n")
      }
    cat("D      ",mu$D_Value[1:10],"\n")
  }
  
  return(mu)
}


DCalc2 <- function(e1, q1, incl1, node1, peri1, e2, q2, incl2, node2, peri2, D_Type="DD") {
  
  Debug = FALSE
  
  # Convert degrees to Radians   
  i2 <- incl2 * pi / 180
  n2 <- node2 * pi / 180
  p2 <- peri2 * pi / 180
  
  i1 <- incl1 * pi / 180
  n1 <- node1 * pi / 180    
  p1 <- peri1 * pi / 180
  
  a <- cos(i1) * cos(i2) + sin(i1) * sin(i2) * cos(n2 - n1)
  
  I21 <- acos(pmax(pmin(a,1),-1 ))
  
  #ADIFF <- ifelse((abs(n1-n2) <= pi),abs(n1-n2), abs(abs(n1-n2) - 2 * pi))
  ADIFF <- abs(n1-n2)
  II21a  <- p2 - p1 + 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21b  <- p2 - p1 - 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21   <- ifelse((ADIFF <= pi),II21a,II21b) 
  if (D_Type == "DD") {
    B1 <- asin(sin(i1) * sin(p1))
    B2 <- asin(sin(i2) * sin(p2))
    G1 <- ifelse((cos(p1) >= 0), n1 + atan(cos(i1) * tan(p1)), pi + n1 + atan(cos(i1) * tan(p1)))
    G2 <- ifelse((cos(p2) >= 0), n2 + atan(cos(i2) * tan(p2)), pi + n2 + atan(cos(i2) * tan(p2)))
    a <- sin(B1) * sin(B2) + cos(B1) * cos(B2) * cos(G2-G1) 
    Theta <- acos( pmin(pmax(a,-1),1))
    D_Value  = sqrt( ((q2 - q1)/(q2 + q1))**2 + ((e2 - e1)/(e2 + e1))**2 + (I21 / pi)**2 +((e2+e1)/2)**2 * (Theta/pi)**2)
  }
  
  if (D_Type == "DSH") {	
    D_Value = sqrt ( (q2 - q1)**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + ( (e2 + e1)/2 * 2 * sin(II21/2) )**2 )
  }
  
  if (D_Type == "DH") {	
    D_Value  = sqrt ( ((q2 - q1)/(q2 + q1))**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + (((e2 + e1) / 2) * 2 * sin(II21/2) )**2 )		
  }
  
  if (Debug == TRUE) {
    n = 10
    cat("e:     ",e1,"\n","e2:    ",e2,"\n")
    cat("i:     ",i1,"\n","i2:    ",i2,"\n")
    cat("p:     ",p1,"\n","p2:    ",p2,"\n")
    cat("n:     ",n1,"\n","n2:    ",n2,"\n")
    cat("q:     ",q1,"\n","q2:    ",q2,"\n")
    cat("I21:   ",I21,"\n")
    if (D_Type != "DD") {
      cat("ADIFF: ",ADIFF,"\n")
      cat("II21:  ",II21,"\n")
    } else {
      cat("B1:    ",B1,"\n","B2:    ",B2,"\n")
      cat("G1:    ",G1,"\n","G2:    ",G2,"\n")
      cat("Theta: ",Theta,"\n")
    }
    cat("D      ",D_Value,"\n")
  }
  
  return(D_Value)
}



DCalc3 <- function(mu, e2, q2, incl2, node2, peri2, D_Type="DD") {
  
  Debug = FALSE
  
  # If it does not already exist, add D_Value column to recieve results
  if ( !("D_Value" %in% colnames(mu)) ) {
    mu["D_Value"] <- NA
  }
  
  # Convert degrees to Radians   
  i2 <- incl2 * pi / 180
  n2 <- node2 * pi / 180
  p2 <- peri2 * pi / 180
  
  i1 <- mu$X_incl * pi / 180
  n1 <- mu$X_node * pi / 180    
  p1 <- mu$X_peri * pi / 180
  
  q1 <- mu$X_q
  e1 <- mu$X_e
  I21 <- acos(cos(i1) * cos(i2) + sin(i1) * sin(i2) * cos(n2 - n1) )
  
  #ADIFF <- ifelse((abs(n1-n2) <= pi),abs(n1-n2), abs(abs(n1-n2) - 2 * pi))
  ADIFF <- abs(n1-n2)
  II21a  <- p2 - p1 + 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21b  <- p2 - p1 - 2 * asin(cos( (i2 + i1)/2 ) * sin( (n2 - n1)/2 ) * sec(I21/2))
  II21   <- ifelse((ADIFF <= pi),II21a,II21b) 
  if (D_Type == "DD" | D_Type == "ALL" ) {
    B1 <- asin(sin(i1) * sin(p1))
    B2 <- asin(sin(i2) * sin(p2))
    G1 <- ifelse((cos(p1) >= 0), n1 + atan(cos(i1) * tan(p1)), pi + n1 + atan(cos(i1) * tan(p1)))
    G2 <- ifelse((cos(p2) >= 0), n2 + atan(cos(i2) * tan(p2)), pi + n2 + atan(cos(i2) * tan(p2)))
    Theta <- acos( sin(B1) * sin(B2) + cos(B1) * cos(B2) * cos(G2-G1) )
    mu$DD  = sqrt( ((q2 - q1)/(q2 + q1))**2 + ((e2 - e1)/(e2 + e1))**2 + (I21 / pi)**2 +((e2+e1)/2)**2 * (Theta/pi)**2)
  }
  
  if (D_Type == "DSH"| D_Type == "ALL") {	
    mu$DSH = sqrt ( (q2 - q1)**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + ( (e2 + e1)/2 * 2 * sin(II21/2) )**2 )
  }
  
  if (D_Type == "DH" | D_Type == "ALL") {	
    mu$DH  = sqrt ( ((q2 - q1)/(q2 + q1))**2 + (e2 - e1)**2 + (2 * sin(I21/2))**2 + (((e2 + e1) / 2) * 2 * sin(II21/2) )**2 )		
  }
  
  if (Debug == TRUE) {
    n = 10
    cat("N:     ",mu$X__[1:n],"\n")
    cat("e:     ",e1[1:n],"\n","e2:    ",e2,"\n")
    cat("i:     ",i1[1:n],"\n","i2:    ",i2,"\n")
    cat("p:     ",p1[1:n],"\n","p2:    ",p2,"\n")
    cat("n:     ",n1[1:n],"\n","n2:    ",n2,"\n")
    cat("q:     ",q1[1:n],"\n","q2:    ",q2,"\n")
    cat("I21:   ",I21[1:n],"\n")
    if (D_Type != "DD") {
      cat("ADIFF: ",ADIFF[1:n],"\n")
      cat("II21:  ",II21[1:n],"\n")
    } else {
      cat("B1:    ",B1[1:n],"\n","B2:    ",B2,"\n")
      cat("G1:    ",G1[1:n],"\n","G2:    ",G2,"\n")
      cat("Theta: ",Theta[1:n],"\n")
    }
    cat("D      ",mu$D_Value[1:10],"\n")
  }
  
  return(mu)
}
