mp_emptycache()
mp_setapikey(key.file = "../manifesto_apikey.txt")

mpds <- mp_maindataset()

test_that("rile computation from dataset equals dataset value", {
  
  mpds.blg <- subset(mpds, countryname=="Bulgaria" &
                           edate > as.Date("2000-01-01"))

  corpus_riles <- rile(mp_corpus(mpds.blg))
  joint_riles <- left_join(corpus_riles,
                           select(mpds.blg, one_of("party", "date", "rile")),
                           by = c("party", "date"))
  
  expect_equal(joint_riles$rile.x,
               joint_riles$rile.y,
               tolerance = 0.1)
  
})

scaling_as_expected <- function(corp, scalingfun, scalingname) {
  
  scale1 <- scalingfun(corp[[1]])
  expect_is(scale1, "numeric")
  expect_false(is.na(scale1))
  
  scale_corp <- scalingfun(corp)
  expect_is(scale_corp, "data.frame")
  expect_true(all(c("party", "date", scalingname) %in% names(scale_corp)))
  expect_false(any(is.na(scale_corp[,scalingname])))
  expect_equal(nrow(scale_corp), length(corp))
}

test_that("corpus and document scaling works", {
  
  mpds <- mp_maindataset()
  mpds.fr <- subset(mpds, countryname == "France")
  
  corp <- mp_corpus(mpds.fr)

  scaling_as_expected(corp, rile, "rile")
#   scaling_as_expected(corp, logit_rile, "logit_rile")

})


## TODO more tests, of other functions

# comparedf$logit.rile <- logit.rile(mpds.fr)

# print(comparedf$logit.rile)