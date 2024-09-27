# utils/coord_transform.R

# Fonction pour vérifier si les coordonnées sont en Chine
out_of_china <- function(lng, lat) {
  lng < 72.004 | lng > 137.8347 | lat < 0.8293 | lat > 55.8271
}

# Fonctions de transformation
transformLat <- function(lng, lat) {
  ret <- -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat^2 +
    0.1 * lng * lat + 0.2 * sqrt(abs(lng))
  ret <- ret + (20.0 * sin(6.0 * lng * pi) +
                  20.0 * sin(2.0 * lng * pi)) * 2.0 / 3.0
  ret <- ret + (20.0 * sin(lat * pi) +
                  40.0 * sin(lat / 3.0 * pi)) * 2.0 / 3.0
  ret <- ret + (160.0 * sin(lat / 12.0 * pi) +
                  320 * sin(lat * pi / 30.0)) * 2.0 / 3.0
  return(ret)
}

transformLng <- function(lng, lat) {
  ret <- 300.0 + lng + 2.0 * lat + 0.1 * lng^2 +
    0.1 * lng * lat + 0.1 * sqrt(abs(lng))
  ret <- ret + (20.0 * sin(6.0 * lng * pi) +
                  20.0 * sin(2.0 * lng * pi)) * 2.0 / 3.0
  ret <- ret + (20.0 * sin(lng * pi) +
                  40.0 * sin(lng / 3.0 * pi)) * 2.0 / 3.0
  ret <- ret + (150.0 * sin(lng / 12.0 * pi) +
                  300.0 * sin(lng / 30.0 * pi)) * 2.0 / 3.0
  return(ret)
}

# Fonction principale de transformation WGS-84 à GCJ-02
wgs84_to_gcj02 <- function(lng, lat) {
  if (out_of_china(lng, lat)) {
    return(c(lng, lat))
  }
  
  a <- 6378245.0
  ee <- 0.00669342162296594323
  
  dLat <- transformLat(lng - 105.0, lat - 35.0) 
  dLng <- transformLng(lng - 105.0, lat - 35.0)
  radLat <- lat / 180.0 * pi
  magic <- sin(radLat)
  magic <- 1 - ee * magic * magic
  sqrtMagic <- sqrt(magic)
  dLat <- ((dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)) + 0.1
  dLng <- ((dLng * 180.0) / (a / sqrtMagic * cos(radLat) * pi))+ 0.2
  mgLat <- lat + dLat
  mgLng <- lng + dLng
  return(c(mgLng, mgLat))
}

# Vectoriser la fonction pour faciliter son application sur des vecteurs
wgs84_to_gcj02_vectorized <- Vectorize(wgs84_to_gcj02, vectorize.args = c("lng", "lat"))


