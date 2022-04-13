# FiveInARow.jl
* Introduction
    
    Five in a row game with GUI, written in Julia with Gtk.jl and QML.jl. 
    <p align="center">
    <img src="figs/example.gif" alt="drawing" width="400"/>
    </p>

* Reference

    Most of the GTK codes are arranged from the repository [GUIAppExample.jl](https://github.com/goropikari/GUIAppExample.jl/tree/master/example/Reversi).
    Most of the QML codes are arranged from the repository [QmlJuliaExamples](https://github.com/barche/QmlJuliaExamples).

    These examples are very useful to learn Julia with GUI.


* How to play
  
    * Use this package and just ```GtkStartGame(;Ratio = 1.5)```.
    * Use this package and just ```QtStartGame(;Ratio = 1.5)```.
    * Run the script ```GtkTest.jl```.
    * Run the script ```QtTest.jl```. 
    * There are some bugs when run the qt version on Linux.

* To do list

    1. Maybe a Blink version.
