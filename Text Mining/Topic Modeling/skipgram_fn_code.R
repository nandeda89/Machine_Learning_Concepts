#' skip_ngram 
#' @param x character list, possibly compressed
#' @param n integer, the gram type (1L for unigram, 2L for bigram, etc..) 
#' @param skip integer, the number of tokens to skip over (0L for simple gram, 1L for one skip, i.e [token X token]), note skip is ignored, set to 0L, on unigrams!
#' @param cflag logical, TRUE indicates compressed string x is input
#' @param filters is an optional character vector dictionary of tokens to exclude, omit if not supplied 
#' @return skip_ngram as named integer vector x 
#' @examples 
#' skip_ngram(as.character(citation)) produces a unigram of citation in list x
#' skip_ngram(string,3L) produces trigram of string in list x
#' skip_ngram(string,2L,3L,1L,badwords) produces skip3-bigram in list x corresponding to [word X X X word] from a compressed list, excludes tokens in badwords list
skip_ngram <- compiler::cmpfun (function( x,  n = 1L, skip = 0L, cflag = FALSE, filters = NULL) {
  stopifnot( is.integer( n ), is.finite( n ), n > 0L, is.integer( skip ), is.finite( skip ), skip > -1L, is.logical( cflag ) )
  if ( cflag == TRUE ) { x %>% memDecompress( "g", asChar = TRUE ) %>% strsplit( "\n" ) %>% unlist -> x }      # decompress
  if ( n == 1L && skip > 0L ) { skip <- 0L } # ignore the skip
  stri_split_boundaries <- stringi::stri_split_boundaries 
  stri_join <- stringi::stri_join  
  options <- stringi::stri_opts_brkiter( type = "word", skip_word_none = TRUE, skip_word_number = FALSE )
  tokens <- unlist( stri_split_boundaries( x, opts_brkiter = options ) )          # Split into word tokens
  if (length ( filters > 0L ) ) { tokens <- tokens[ !tokens %in% filters ] }       # filters designated vocabulary
  # if we didn't detect any words or number of tokens is less than n return empty vector 
  if ( all( is.na( tokens )) || length( tokens ) < n + skip ) { character(0) } else { 
    if ( skip == 0L) { sapply(1:( length( tokens ) - n - 1L ),       function(i) stri_join( tokens[i:(i + n - 1L)], collapse = " "))} else {
      sapply(1:( length( tokens ) - n - skip -1L ), function(i) stri_join( c( tokens[i], tokens[(i + skip + 1L):(i + skip + n - 1L)]), collapse = " ")) } }
} , options = list( optimize = 3) )

# string <- c( "This scope of this report is to perform exploratory data analysis on the sample data ",
# "set. The specific data set contains English, German, Russian and Finnish language data sets for",
# " exploration. This milestone report focuses on exploring English language datasets within the specific,
# "data set. This data set contains en_US.news.txt, en_US.blogs.txt, and en_US.twitter.txt files." )