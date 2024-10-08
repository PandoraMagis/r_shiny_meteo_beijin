# UI changes
ui_radio <- 

  
  # Main layout
    # Large window on the left
    div(

      tags$link(rel = "stylesheet", type = "text/css", href = "./radio_selector/style.css"),
      tags$head(includeCSS("./radio_selector/style.css")),
  
      # JavaScript to bind custom radio buttons with Shiny inputs
      tags$script(HTML("
        $(document).on('change', 'input[name=district-radio]', function() {
          var selectedValue = $('input[name=district-radio]:checked').val();
          Shiny.setInputValue('district_radio', selectedValue);
        });
        $(document).on('change', 'input[name=band]', function() {
          var selectedValue = $('input[name=band]:checked').val();
          Shiny.setInputValue('month_radio', selectedValue);
        });
        $(document).on('input', '#custom_slider', function() {
        var sliderValue = $('#custom_slider').val();
        Shiny.setInputValue('custom_slider', sliderValue);
      });
      $(document).on('input', '#custom_slider_hour', function() {
        var sliderValue = $('#custom_slider_hour').val();
        Shiny.setInputValue('custom_slider_hour', sliderValue);
      });
      $(document).on('change', '#theme-switch-checkbox', function() {
          var isChecked = $(this).is(':checked');
          Shiny.setInputValue('theme_switch_checkbox', isChecked);
        });
      ")),
      div(class = "window-with-bg",
        # Circular Radio Buttons
        tags$head(includeCSS("./radio_selector/analog_knob_latestV2.css")),
        tags$div(
          class = "radio-input",
          style = "display: flex; flex-direction: column; align-items: center;",  # Centering styles
          tags$div(
            class = "radio-input-path",
            
            # 5 Districts Radio Buttons
            tags$div(class = "radioContainer radioContainer1",
                    tags$label(class = "label1", `for` = "value-1", "2013"),
                    tags$input(class = "radio1", value = "2013", name = "district-radio", id = "value-1", type = "radio", checked = "checked")
            ),
            tags$div(class = "radioContainer radioContainer2",
                    tags$label(class = "label2", `for` = "value-2", "2014"),
                    tags$input(class = "radio2", value = "2014", name = "district-radio", id = "value-2", type = "radio")
            ),
            tags$div(class = "radioContainer radioContainer3",
                    tags$label(class = "label3", `for` = "value-3", "2015"),
                    tags$input(class = "radio3", value = "2015", name = "district-radio", id = "value-3", type = "radio")
            ),
            tags$div(class = "radioContainer radioContainer4",
                    tags$label(class = "label4", `for` = "value-4", "2016"),
                    tags$input(class = "radio4", value = "2016", name = "district-radio", id = "value-4", type = "radio")
            ),
            tags$div(class = "radioContainer radioContainer5",
                    tags$label(class = "label5", `for` = "value-5", "2017"),
                    tags$input(class = "radio5", value = "2017", name = "district-radio", id = "value-5", type = "radio")
            )
          ),
          tags$div(class = "knob",
                  tags$div(class = "center")
          )
        ), # fin radio buttons
        tags$head(includeCSS("./radio_selector/radio_buttons.css")),
        div(class = "radio-month",
            tags$form(
              tags$label(
                tags$input(type = "radio", name = "band", value = "jan", checked = TRUE),
                tags$span("JAN")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "fev"),
                tags$span("FEV")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "mar"),
                tags$span("MAR")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "avr"),
                tags$span("AVR")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "mai"),
                tags$span("MAI")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "jun"),
                tags$span("JUN")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "jui"),
                tags$span("JUI")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "aou"),
                tags$span("AOU")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "sep"),
                tags$span("SEP")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "oct"),
                tags$span("OCT")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "nov"),
                tags$span("NOV")
              ),
              tags$label(
                tags$input(type = "radio", name = "band", value = "dec"),
                tags$span("DEC")
              )
              
            )),#fin de radio buttons
        tags$head(includeCSS("./radio_selector/slider_input.css")),
        
        div(class = "slider",
            h6("jour"),
            tags$input(type = "range", class = "range-style", min = 1, max = 31, id = "custom_slider",value = 3,style = "margin-bottom: 20px;"),
            h6("heure"),
            tags$input(type = "range", class = "range-style", min = 0, max = 23, id = "custom_slider_hour",value=0)
            # Output to display the selected value
            
        )
      )#fin div class = background
    )

