library(ggplot2)
library(svglite)
library(rsvg)
library(fabricjsR)
library(htmltools)

# try to make a ggplot
#  get svg with svglite
#  convert svg to png
#  draw on fabric.js canvas
s <- svgstring(standalone=FALSE)
ggplot(data.frame(y=sin(1:10)), aes(x=1:10,y=y)) + geom_smooth()
s()
dev.off()

gg_png <- rsvg_png(charToRaw(s()))
gg_base64 <- sprintf(
  'data:image/png;base64,%s',
  base64enc::base64encode(gg_png)
)

# make sure we have a working base64 png
browsable(
  tags$img(src=gg_base64)
)

browsable(
  attachDependencies(
    tagList(
      tags$canvas(id="c", height="500", width="500"),
      tags$script(HTML(sprintf(
"
var canvas = new fabric.Canvas('c');
fabric.Image.fromURL(
  '%s',
  function(oImg){
    oImg.scale(0.5)
    canvas.add(oImg);
  }
)
"       ,
        gg_base64
      )))
    ),
    htmlwidgets:::widget_dependencies("fabric","fabricjsR")[[2]]
  )
)




browsable(
  attachDependencies(
    tagList(
      tags$canvas(id="c", height="500", width="500"),
      tags$script(sprintf(
"
var canvas = new fabric.Canvas('c');
fabric.loadSVGFromURL(
  %s,
  function(objects,options){
    var obj = fabric.util.groupSVGElements(objects, options);
    canvas.add(obj).renderAll();
  }
)
"       ,
        shQuote(
          paste0(
            "data:image/svg+xml,",
            shiny:::URLencode(
              #  gsub out the CDATA and still not right
              #gsub(x=s(),pattern="(.*)(<!\\[CDATA\\[)(.*)(\\]\\]>)(.*)","\\1\\3\\5")
              s()
            )
          )
        )
      ))
    ),
    htmlwidgets:::widget_dependencies("fabric","fabricjsR")[[2]]
  )
)