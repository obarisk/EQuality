library(shiny)

N2p <- function(nSubj, rc=.1, nCond=2){
  Fcut <- (rc*rc/(nCond-1))/((1-rc*rc)/(nSubj-nCond))
  return( 1-pf(Fcut, nCond-1, nSubj-nCond) )
}

q2N <- function(q ,rc=.1, nCond=2){
  nUpper <- nCond+1
  p0 <- N2p(nUpper, rc, nCond)
  if( p0 <= (1-q) ) return( NA )
  while ( p0 > (1-q) ){
    nUpper <- nUpper*10
    p0 <-  N2p(nUpper, rc, nCond)
  }
  return(uniroot(function(N) {N2p(N, rc, nCond)-(1-q)}, 
                              lower = nCond+1, upper = nUpper, tol = 1e-9)$root)
}

shinyServer(function(input, output) {
  
  output$pvalue <- renderText({
    input$RUN_p
    N <- isolate(input$N_p)
    rc <- isolate(input$rc_p)
    L <- isolate(input$L_p)
    pvalue <- round(1-N2p(N, rc, L), 3)
    if( is.nan(pvalue) ){
      "NaN"
    }else{
      pvalue
    }
  })

  output$NSubj <- renderText({
    input$RUN_n
    Q <- isolate(input$Q_n)
    rc <- isolate(input$rc_n)
    L <- isolate(input$L_n)
    N <- ceiling(q2N(Q, rc, L)/L)
  })

})
