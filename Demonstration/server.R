library(shiny)
library(ggplot2)
library(reshape)

N2p <- function(nSubj, rc=.1, nCond=2){
  Fcut <- (rc*rc/(nCond-1))/((1-rc*rc)/(nSubj-nCond))
  return( 1-pf(Fcut, nCond-1, nSubj-nCond) )
}

q2N <- function(q ,rc=.1, nCond=2){
  nUpper <- nCond+1
  p0 <- N2p(nUpper, rc, nCond)
  if( p0 <= (1-q) ) return(NA)
  while ( p0 > (1-q) ){
    nUpper <- nUpper*10
    p0 <-  N2p(nUpper, rc, nCond)
  }
  return(uniroot(function(N) {N2p(N, rc, nCond)-(1-q)}, lower = nCond+1, 
                              upper = nUpper, tol = 1e-9)$root)
}

shinyServer(function(input, output) {

  output$PvsNPlot_N <- renderPlot({
    rc <- input$rc_N
    L <- input$L_N
    if( L >= 2 ){
      tt <- N2p(L+1, rc, L)
      N2 <- ceiling(q2N(q=.99, rc=rc, L)/L)
      dat <- data.frame(nSubj=L+1:N2, Prob=N2p((L+1:N2)*L, rc, L))
      dat$nProb <- 1-dat$Prob
      Nnow <- input$sliderInputN*L
      if( length(Nnow)==0 ) Nnow=N2 
      dat$Pass <- ifelse(dat$Prob<N2p(Nnow, rc, L), 
                         "Probability of rxe >= rc", "Probability of rxe < rc")
      if( L >= 2){
        ggplot(dat, aes(x=nSubj, y=nProb, Pass)) + 
          xlab("number of subjects in each condition") + 
          ylab("the probability of successful randomization") + 
          geom_point(aes(colour=Pass)) + 
          theme(text=element_text(family="NovaMono", size=rel(3.5))) +
          scale_color_manual(values = c("Probability of rxe >= rc" = "#00bfc4", 
                                        "Probability of rxe < rc" = "#f8766d"), guide=F) 
      }else{
        par(family="NovaMono")
        plot(1:10, 1:10, pch="", bty="n", yaxt="n", xaxt="n", ylab="", xlab="")
        text(5, y=6, "Probability cannot be calculated under", cex=1.3)
        text(5, y=5, "this combination of parameters.", cex=1.3)
      }
    }else{
      par(family="NovaMono")
      plot(1:10, 1:10, bty="n", xaxt="n", yaxt="n", pch="", ylab="", xlab="")
      text(5, y=6, "Probability cannot be calculated under", cex=1.3)
      text(5, y=5, "this combination of parameters.", cex=1.3)
    }
  })
  
  output$sliderInputN <- renderUI({
    if( input$L_N >= 2 ){
      N.99 <- ceiling(q2N(q=.99, rc=input$rc_N, input$L_N)/input$L_N)
      sliderInput("sliderInputN", label="Number of subjects in each condition", 
                  min=input$L_N+1, max=N.99, value=round((N.99-input$L_N-1)/2, 2))
    }else{
    }
  })
  
  output$Prob <- renderText({
    if( length(input$sliderInputN)==0 | input$L_N<2 ){
    }else if( input$sliderInputN < input$L_N ){
    }else{
      round(1-N2p(input$sliderInputN*input$L_N, input$rc_N, input$L_N), 3)
    }
  })
  
  output$PvsNPlot_P <- renderPlot({
    rc <- input$rc_P
    L <- input$L_P
    if( L >= 2 ){
      tt <- N2p(L+1, rc, L)
      N2 <- ceiling(q2N(q=.99, rc=rc, L)/L)
      dat <- data.frame(nSubj=L+1:N2, Prob=N2p((L+1:N2)*L, rc, L))
      dat$nProb <- 1-dat$Prob
      Pnow <- input$sliderInputP
      if( length(Pnow)==0 ) Pnow=mean(dat$nProb)
      dat$Pass <- ifelse(dat$nSubj>q2N(q=Pnow, rc=rc, L)/L, 
                         "Probability of rxe >= rc", "Probability of rxe < rc")
      if( L >= 2){
        ggplot(dat, aes(y=nSubj, x=nProb, Pass)) + 
          ylab("number of subjects in each condition") + 
          xlab("acceptable good-randomization rate") + 
          geom_point(aes(colour=Pass)) + 
          theme(text=element_text(family="NovaMono", size=rel(3.5))) + 
          scale_color_manual(values = c("Probability of rxe >= rc" = "#00bfc4", 
                                        "Probability of rxe < rc" = "#f8766d"), guide=F) 
      }else{
        par(family="NovaMono")
        plot(1:10, 1:10, pch="", bty="n", yaxt="n", xaxt="n", ylab="", xlab="")
        text(5, y=6, "Sample size cannot be calculated under", cex=1.3)
        text(5, y=5, "this combination of parameters.", cex=1.3)
      }
    }else{
      par(family="NovaMono")
      plot(1:10, 1:10, bty="n", xaxt="n", yaxt="n", pch="", ylab="", xlab="")
      text(5, y=6, "Sample size cannot be calculated under", cex=1.3)
      text(5, y=5, "this combination of parameters.", cex=1.3)
    }
  })

  output$sliderInputP <- renderUI({
    if( input$L_P >= 2 ){
      Pmin <- max(.1, floor(N2p(2*input$L_P, rc=input$rc_P, input$L_P)))
      Pmax <- min(.99, ceiling(N2p(250*input$L_P, rc=input$L_P)))
      sliderInput("sliderInputP", label="Acceptable good-randomization rate", 
                  min=Pmin, max=Pmax, value=round((Pmax+Pmin)/2, 2), step=0.001)
    }else{
    }
  })
  
  output$N <- renderText({
    if( length(input$sliderInputP)==0 | input$L_P<2 ){
    }else{
      ceiling(q2N(input$sliderInputP, input$rc_P, input$L_P)/input$L_P)
    }
  })
})
