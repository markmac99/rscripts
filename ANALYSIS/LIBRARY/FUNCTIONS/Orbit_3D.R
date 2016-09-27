#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#
#-- Description:
#
#   This script contains a set of generic routines to produce orbital plots
#   in a 3D projection.
#
#   To plot an orbit, the routine "orbit" is called.
#
#   Orbital elements are represented as a numeric vector as follows:
#
#     c(a, e, I, O, w)
#
#   Where:
#     a - perihelion distance of the reference orbit
#     e - eccentricity f the reference orbit
#     i - inclination of the refernce orbit (in degrees)
#     o - longitude of ascending node
#     w - argument of perihelion of the reference orbit (im degrees)
#
#-- Acknowledgements
#
#   The R scripts in this module are an adaption of routines published originally as
#   Python scripts by Joe Hahn (http://gemelli,spacescience.org/~hahnjm)
#
#-- Version History
#  ----------------
#   Vers  Date          Note
#   1.0   20/09/2016    First release
#
#
#=============================================================================


library(rgl)

rotate_x <- function(Pxyz, angle) {
# rotate about X axis (angle in Radians)
  sn = sin(angle)
  cs = cos(angle)
  return( cbind( Pxyz[,1], Pxyz[,2]*cs + Pxyz[,3]*sn, -Pxyz[,2]*sn + Pxyz[,3]*cs ) ) 
  }
 
rotate_y <- function(Pxyz, angle) {
# rotate about Y axis (angle in Radians)
  sn = sin(angle)
  cs = cos(angle)
  return( cbind(Pxyz[,1]*cs - Pxyz[,3]*sn, Pxyz[,2], Pxyz[,1]*sn + Pxyz[,3]*cs ) ) 
  }

rotate_z <- function(Pxyz, angle) {
# rotate about Z axis (angle in Radians)
  sn = sin(angle)
  cs = cos(angle)
  return( cbind(Pxyz[,1]*cs + Pxyz[,2]*sn, -Pxyz[,1]*sn + Pxyz[,2]*cs, Pxyz[,3] ) ) 
  }

elem_deg_2_rad <- function(elements) {
#-- Convert orbital elements in degrees to radians
    const <- pi / 180
  return( c(elements[1:2],elements[3:5] * const))
  }

polar_2_cart <- function(r, theta) {
#-- Convert polar coordinates to cartesian coordinates
  x = matrix(r * cos(theta), ncol=1)
  y = matrix(r * sin(theta), ncol=1)
  return(cbind(x,y))
  }

kepler_solve <- function(e, M, max_error) {
#Solve kepler's equation (Danby's algorithm).
  pi_2 <- 2*3.141592653589793
  M_mod <- M %% pi_2
  s <- M_mod * 0 + 1
  s[sin(M_mod) < 0.0] = -1
  E = M_mod + 0.85*s*e
  max_iter = 16
  for (i in 0:max_iter) {
    es = e*sin(E)
    ec = e*cos(E)
    f = E - es - M_mod
    error = max(abs(f))
    if (error < max_error) { break }
    df = 1.0 - ec
    ddf = es
    dddf = ec
    d1 = -f/df
    d2 = -f/(df + d1*ddf/2.0)
    d3 = -f/(df + d2*ddf/2.0 + d2*d2*dddf/6.0)
    E = E + d3
  }
  if (error > max_error) { 
      print("ERROR: kepler_solve did not converge - max error exceeded, error = ", error)
      }
  return(E)
  }

elements_2_polar <- function(a,e,M,max_error) {
#-- Convert orbital elements to polar coordinates
  E <- kepler_solve(e, M, max_error)
  r <- matrix(a*(1 - e*cos(E)),ncol=1)
  f <- matrix(2.0*atan( sqrt((1 + e)/(1 - e))*tan(E/2) ),ncol=1)
  z <- matrix(r*0.0,ncol=1)
  return(cbind(r, f, z))
  }

el2xyz <- function (elements, Mplot, max_error) {
#convert orbit elements to cartesian coordinates and velocities.
  rfz = elements_2_polar(elements[1], elements[2], Mplot, max_error)
  attributes(rfz)
  xy  = polar_2_cart(rfz[,1], rfz[,2])
  xyz = rotate_z(cbind(xy, rfz[,3]), -elements[5])
  xyz = rotate_x(xyz, -elements[3])
  xyz = rotate_z(xyz, -elements[4])
  return(xyz)
  }

orbit <- function(elements) {
#-- calculate and plot an orbit in 3D
  Resolution = 10001
  max_error <- 1.0e-10
  Mplot <- seq(0, 2*pi, (2 * pi) / Resolution)
  elements_r = elem_deg_2_rad(elements)
  xyz = el2xyz(elements_r, Mplot, max_error)
  xyz = rotate_y(xyz, elements_r[4])
  xyz = rotate_x(xyz, elements_r[3])
  xyz = rotate_z(xyz, elements_r[5])
  return(xyz)
}

Mercury_Orbit <- function() {
  a     = 0.387098750
  e     = 0.205633707
  i_deg = 7.00427693
  o_deg = 48.3155706
  w_deg = 29.1597880
  m_deg = 109.448230
  return(c(a,e,i_deg,o_deg,w_deg,m_deg))
}

Venus_Orbit <- function() {
  a = 0.72333199
  e = 0.00677323
  i_deg = 3.39471
  o_deg = 76.68069
  w_deg = 0.0
  m_deg = 0.0
  return(c(a,e,i_deg,o_deg,w_deg,m_deg))
}

Earth_Orbit <- function() {
  a = 1.0
  e = 0.01671022
  i_deg = 0.00005
  o_deg = -11.26064
  w_deg = 0.0
  m_deg = 0.0
  return(c(a,e,i_deg,o_deg,w_deg,m_deg))
}

 