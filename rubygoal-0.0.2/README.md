#Bienvenidos a RubyGoal!

## ¿Qué es RubyGoal?

RubyGoal es un juego en el cual tú serás el coach de un equipo de
fútbol.

La estrategia del coach la vas a tener que implementar tú en ruby.

## Dependencias

GNU/Linux, Asegúrate tener todas las dependencias instaladas.

Ubuntu/Debian:

```bash
# Gosu's dependencies for both C++ and Ruby
sudo apt-get install build-essential freeglut3-dev libfreeimage-dev libgl1-mesa-dev \
                     libopenal-dev libpango1.0-dev libsdl-ttf2.0-dev libsndfile-dev \
                     libxinerama-dev
```

Para otras distros: https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux

## ¿Cómo hago para correrlo?

```bash
gem install rubygoal
```

Correr el juego con los `Coach` de ejemplo
```bash
rubygoal
```

Correr el juego con tu implementación de `Coach`
```bash
rubygoal coach_1.rb
```

Correr el juego con tu implementación de ambos `Coach`
```bash
rubygoal coach_1.rb coach_2.rb
```

## ¿Cómo hago para implementar mi Coach?

Mirate los `Coach` ya definidos en `lib/rubygoal/coaches`, sobre todo lee con
atención y en su totalidad `lib/rubygoal/coaches/template.rb`

## Legal

Todo el código fuente, salvo los archivos bajo la carpeta `media/`, está
licenciado bajo los términos de la licencia del MIT. Ver el archivo `MIT-LICENSE`
bajo la ruta de la gema.

La imagen de Alberto Kesman utilizada en el archivo `media/goal.png` fue
tomada de https://commons.wikimedia.org/wiki/File:Albertok.jpg que se
encuentra licenciada bajo los términos de la licencia CC-BY-SA 3.0
(https://creativecommons.org/licenses/by-sa/3.0/deed.es). Como
consecuencia, el archivo `media/goal.png` queda licenciado también bajo
esta licencia como trabajo derivado.
