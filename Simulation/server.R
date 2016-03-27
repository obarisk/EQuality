library(shiny)
library(ggplot2)
library(magrittr)
library(grid)

shinyServer(function(input, output) {
  # Global variable to control fallback
  IsRunning <- TRUE
  # Plot
  output$distPlot <- renderPlot({
    input$RUN
    R <- switch(isolate(input$R), "1"=100, "2"=500, "3"=1000)
    nsub <- isolate(input$N)
    L <- isolate(input$L)
    rc <- isolate(input$rc)
    if( L < 2 ){
      playout <- grid.layout(2, 1, unit(1, "npc"), unit(c(.1, .9), "npc"))
      pushViewport(viewport(layout=playout))
      pushViewport(viewport(layout.pos.row=1, layout.pos.col=1))
      grid.text("The number of experimental condition should greater than 2.", x=.4,
                gp=gpar(fontfamily="sans", col="red", cex=1.2))
      IsRunning <<- FALSE
    }else{
      g <- as.factor(rep(1:L, nsub))
      dm <- model.matrix(~g)[, 1:nlevels(g)]
      rxe <- matrix(rep(NA, R), R, 1)
      for( r in 1:R ){
        y <- rnorm(nsub*L, 0, 1)
        rxe[r] <- sqrt(1-var(residuals(.lm.fit(dm, y)))/var(y))
      }
      pvalue <<- round(1 - mean(rxe>=rc), 3)
      IsRunning <<- FALSE
      dat <- ifelse(rxe<rc, "rxe<rc", "rxe>=rc") %>% data.frame(rxe=rxe, Result=.)
      #dat <- data.frame(rxe=rxe, success=rxe<=rc)
      ypos <- cut(dat$rxe, seq(min(dat$rxe), max(dat$rxe), .01)) %>% table %>% max * 1.1 
      gl <- grid.layout(nrow=2, ncol=1, heights=unit(c(.1, .9), "npc"))
      pushViewport(viewport(layout=gl))
      pushViewport(viewport(layout.pos.col=1, layout.pos.row=1))
      grid.text("The probability of successful randomization is", x=.28,
                y=.5, gp=gpar(fontsize=unit(12, "npc"), cex=1.2))
      grid.text(sprintf("%.2f", pvalue), x=.56, y=.5, 
                gp=gpar(fontsize=unit(15, "npc"), col="red", cex=1.2))
      popViewport()
      gplot <- ggplot(dat, aes(x=rxe, fill=Result)) + 
                      geom_histogram(binwidth=.01, colour="black", size=rel(.3)) + 
                      xlab(expression(r[x*epsilon])) +
                      theme(text=element_text(family="NovaMono", size=rel(4)), 
                            legend.text=element_text(size=rel(4)),
                            legend.title=element_text(size=rel(3.7))) + 
                      scale_fill_manual(values=c("rxe>=rc"="#f8766d", "rxe<rc"="#00bfc4"), 
                                        labels=expression(r[x*epsilon]<r[c],r[x*epsilon]>=r[c]))
      print(gplot, vp=viewport(layout.pos.col=1, layout.pos.row=2))
    }
  })
  #output$pvalue <- renderText({
  #  input$RUN
  #  while(IsRunning){
  #    #Sys.sleep(1)
  #  }
  #  IsRunning <<- TRUE
  #  return(pvalue)
  #})
})
