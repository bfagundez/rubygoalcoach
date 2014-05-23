# RubyGoal - Fútbol para Rubistas
#
# Este documento contiene varias implementaciones mínimas de un entrenador de RubyGoal.#
#
# Esta clase debe implementar, como mínimo, los métodos `name` y `formation(match)`
# Esta clase debe ser implementada dentro del módulo Rubygoal

module Rubygoal
  class MyCoach < Coach
    # Indica el nombre del equipo
    # Debe retornar un string
    def name
      "My team name"
    end

    # Este método debe devolver una instancia de Formation indicando como
    # se tienen que parar los jugadores en la cancha
    #
    # Este método es invocado constantemente (varias veces por segundo)
    # proporcionando información de como va el partido utilizando el
    # parámetro match
    def formation(match)
      formation = Formation.new

      # La clase Formation tiene varios helpers para ayudar a definir la
      # formación del equipo
      #
      # La cancha se divide en una matriz de 5 por 5
      #
      #   ------------------------------
      #   | N     N     N     N     N  |
      #   |                            |
      #   | N     N     N     N     N  |
      # A |                            | A
      # R | N     N     N     N     N  | R
      # C |                            | C
      # O | N     N     N     N     N  | O
      #   |                            |
      #   | N     N     N     N     N  |
      #   ------------------------------
      #
      # Esto es un ejemplo que posiciona jugadores en columnas de la matriz
      #
      # Los tipos de jugadores válidos son :average, :fast, :captain
      # Se usa :none para las posiciones que no se usen en la línea
      #
      # Restricciones:
      # Exactamente un :captain
      # Exactamente tres :fast
      # Exactamente seis :average
      #
      # :captain -> Este jugador es el más rápido y preciso del equipo
      # :fast -> Estos jugadores son más rápidos que los demás (aunque más lentos que
      #          el capitán del equipo)
      # :average -> Estos jugadores completan el equipo
      #
      # El arquero no hay que especificarlo, ya viene incluido por defecto
      formation.defenders = [:none, :average, :average, :average, :none]
      formation.midfielders = [:average, :fast, :captain, :none, :average]
      formation.attackers = [:none, :fast, :none, :fast, :average]

      # Esto produce la siguiente alineación
      #
      #   ------------------------------
      #   | N     N     A     N     N  |
      #   |                            |
      #   | A     N     F     N     F  |
      # A |                            | A
      # R | A     N     C     N     N  | R
      # C |                            | C
      # O | A     N     N     N     F  | O
      #   |                            |
      #   | N     N     A     N     A  |
      #   ------------------------------

      formation
    end
  end

  # Lo siguiente es otra implementación posible de una instancia de Coach

  class AnotherCoach < Coach
    def name
      "Maeso FC"
    end

    # El método formation debe devolver una instancia de Formation
    # El siguiten ejemplo muestra como controlar la posición de los jugadores
    # de una forma más fina, usando el método `lineup`
    #
    def formation(match)
      formation = Formation.new

      # Por defecto el valor de formation.lineup es
      #
      # [
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      # ]
      #
      # Este valor DEBE sobreescribirse con una formación que incluya las
      # cantidades correctas de :average, :fast y :captain
      #
      # Para este tipo de estrategias es importante siempre considerar que el arco
      # que atacas es el de la derecha.
      #
      # En el siguiente ejemplo, la formación 4322 puede interpretarse
      # de la siguiente manera
      #                |                            |
      #      defensa   |     medio campo            | delantera
      # [              |                            |
      #   [  :average, | :none, :average, :none,    | :none     ],
      #   [  :fast,    | :none, :none,    :average, | :none     ],
      #   [  :none,    | :none, :captain, :none,    | :fast     ],
      #   [  :fast,    | :none, :none,    :average, | :average  ],
      #   [  :average, | :none, :average, :none,    | :none     ],
      # ]              |                            |
      #                |                            |
      #
      # Usando `lineup`, la línea mas defensiva son los primeros elementos de
      # cada uno de los arrays (:average, :fast, :none, :fast, :average)
      #
      # La segunda línea (entre la defensa y los mediocampistas) no tiene jugadores
      # (son todos :none)
      #
      # La tercer línea, la que corresponde a los mediocampistas, son el tercer
      # elemento de cada array (:average, :none, :captain, :none, :average)
      #
      # La cuarta línea está ubicada entre los mediocampistas y delanteros
      # (:none, :average, :none, :average, :none)
      #
      # Los últimos elementos de los arrays corresponden a la línea de
      # delanteros (:none, :none, :fast, :average, :none)
      formation.lineup = [
        [:average, :none, :average, :none,    :none],
        [:fast,    :none, :none,    :average, :none],
        [:none,    :none, :captain, :none,    :fast],
        [:fast,    :none, :none,    :average, :average],
        [:average, :none, :average, :none,    :none],
      ]

      formation
    end
  end

  # Otra implementación posible de una instancia de Coach

  # Gran parte de la gracia de este juego está en hacer cambios en la formación
  # a medida que va transcurriendo el partido
  #
  # La instancia de `match` que recibe el método `formation` contiene información
  # sobre el partido y el rival de turno
  #
  # Veamos un ejemplo

  class MyCoach < Coach
    def name
      "Villa Pancha"
    end

    def formation(match)
      formation = Formation.new

      # El método `me` trae información sobre mi equipo en el partido
      #
      # me.winning? indica si estoy ganando
      # me.losing? y me.draw? son análogos al anterior :)
      # me.score me indica la cantidad exacta de goles que marcó mi equipo
      if match.me.winning?
        formation.defenders = [:average, :average, :average, :captain, :average]
        formation.midfielders = [:average, :none, :fast, :none, :average]
        formation.attackers = [:none, :fast, :none, :fast, :none]
        #
        # El método `time` indica cuanto tiempo (segundos) le queda al partido.
        # Devuelve un número entre 120 y 0 (120 cuando comienza el partido)
      elsif match.time < 10
        formation.defenders = [:none, :average, :average, :average, :none]
        formation.midfielders = [:average, :average, :captain, :none, :average]
        formation.attackers = [:fast, :fast, :none, :fast, :average]
      else
        #
        # El método `other` devuelve información básica del rival. Tiene los mismos
        # métodos que `me`.
        #
        # En particular, se puede acceder a la formación definida por el equipo
        # contrario. En la siguiente linea, a modo de ejemplo, se estableció
        # una táctica `espejo` con respecto al rival (posiciono mis jugadores en forma
        # simétrica)
        formation.lineup = match.other.formation.lineup
      end

      formation
    end
  end
end
