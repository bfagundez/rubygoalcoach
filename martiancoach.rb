# RubyGoal - Fútbol para Rubistas
#
# Este documento contiene varias implementaciones mínimas de un entrenador de RubyGoal.#
#
# Esta clase debe implementar, como mínimo, los métodos `name` y `formation(match)`
# Esta clase debe ser implementada dentro del módulo Rubygoal

module Rubygoal
  class Martiancoach < Coach
    # Indica el nombre del equipo
    # Debe retornar un string
    def name
      "Martians FC"
    end

    def formation(match)
      formation = Formation.new

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
      # Los tipos de jugadores válidos son :average, :fast, :captain
      # Restricciones:
      # Exactamente un :captain
      # Exactamente tres :fast
      # Exactamente seis :average
      # :captain -> Este jugador es el más rápido y preciso del equipo
      # :fast -> Estos jugadores son más rápidos que los demás (aunque más lentos que
      #          el capitán del equipo)
      # :average -> Estos jugadores completan el equipo
      #

      #formation.defenders = [:none, :average, :average, :average, :none]
      #formation.midfielders = [:average, :fast, :none, :none, :average]
      #formation.attackers = [:none, :fast, :captain, :fast, :average]
      baselineup = [
          [:none,       :average,   :none,      :none,        :none ],
          [:average,    :none,      :none,      :average,     :fast ],
          [:none,       :none,      :captain,   :none,        :fast ],
          [:average,    :none,      :none,      :average,     :none ],
          [:none,       :average,   :none,      :none,        :fast ],
        ]


      aggressive = [
          [:none,       :none,   :average,      :none,        :none ],
          [:average,    :none,      :none,      :average,     :fast ],
          [:none,       :none,      :none,   :captain,        :fast ],
          [:average,    :none,      :none,      :average,     :none ],
          [:none,       :none,   :average,      :none,        :fast ],
        ]

      conservative = [
          [:none,       :average,   :none,      :fast,        :none ],
          [:average,    :none,      :none,      :none,        :average],
          [:none,       :none,      :captain,   :fast,        :none ],
          [:average,    :none,      :none,      :none,        :average ],
          [:none,       :average,   :none,      :fast,        :none ],
        ]

      uruguayan = [
          [:average,       :average,   :none,      :none,        :none ],
          [:average,    :fast,      :none,      :none,     :none ],
          [:fast,       :captain,      :none,   :none,        :none ],
          [:average,    :fast,      :none,      :none,     :none ],
          [:average,       :average,   :none,      :none,        :none ],
        ]

      formation.lineup = baselineup



      # me.winning? indica si estoy ganando
      # me.losing? y me.draw? son análogos al anterior :)
      # me.score me indica la cantidad exacta de goles que marcó mi equipo
      if match.me.winning?
        formation.lineup = conservative
      end

      if match.me.winning? and ( match.time < 20 )
        formation.lineup = uruguayan
      end

      if match.me.losing?
        formation.lineup = baselineup
      end

      if match.me.losing? and ( match.me.score - match.other.score ) == 1
        formation.lineup = baselineup
      end

      if match.me.losing? and ( match.me.score - match.other.score ) > 2
        formation.lineup = aggressive
      end

      # if match.me.winning? and ( match.other.score - match.me.score ) > 2
      #   formation.lineup = uruguayan
      # end

      # elsif match.time < 10
      #   formation.defenders = [:none, :average, :average, :average, :none]
      #   formation.midfielders = [:average, :average, :captain, :none, :average]
      #   formation.attackers = [:fast, :fast, :none, :fast, :average]
      # else
      #   #
      #   # El método `other` devuelve información básica del rival. Tiene los mismos
      #   # métodos que `me`.
      #   #
      #   # En particular, se puede acceder a la formación definida por el equipo
      #   # contrario. En la siguiente linea, a modo de ejemplo, se estableció
      #   # una táctica `espejo` con respecto al rival (posiciono mis jugadores en forma
      #   # simétrica)
      #   formation.lineup = match.other.formation.lineup
      # end
      formation
    end
  end

  # Lo siguiente es otra implementación posible de una instancia de Coach

  # class AnotherCoach < Coach
  #   def name
  #     "Maeso FC"
  #   end

  #   # El método formation debe devolver una instancia de Formation
  #   # El siguiten ejemplo muestra como controlar la posición de los jugadores
  #   # de una forma más fina, usando el método `lineup`
  #   #
  #   def formation(match)
  #     formation = Formation.new

  #     # Por defecto el valor de formation.lineup es
  #     #
  #     # [
  #     #   [:none, :none, :none, :none, :none],
  #     #   [:none, :none, :none, :none, :none],
  #     #   [:none, :none, :none, :none, :none],
  #     #   [:none, :none, :none, :none, :none],
  #     #   [:none, :none, :none, :none, :none],
  #     # ]
  #     #
  #     # Este valor DEBE sobreescribirse con una formación que incluya las
  #     # cantidades correctas de :average, :fast y :captain
  #     #
  #     # Para este tipo de estrategias es importante siempre considerar que el arco
  #     # que atacas es el de la derecha.
  #     #
  #     # En el siguiente ejemplo, la formación 4322 puede interpretarse
  #     # de la siguiente manera
  #     #                |                            |
  #     #      defensa   |     medio campo            | delantera
  #     # [              |                            |
  #     #   [  :average, | :none, :average, :none,    | :none     ],
  #     #   [  :fast,    | :none, :none,    :average, | :none     ],
  #     #   [  :none,    | :none, :captain, :none,    | :fast     ],
  #     #   [  :fast,    | :none, :none,    :average, | :average  ],
  #     #   [  :average, | :none, :average, :none,    | :none     ],
  #     # ]              |                            |
  #     #                |                            |
  #     #
  #     # Usando `lineup`, la línea mas defensiva son los primeros elementos de
  #     # cada uno de los arrays (:average, :fast, :none, :fast, :average)
  #     #
  #     # La segunda línea (entre la defensa y los mediocampistas) no tiene jugadores
  #     # (son todos :none)
  #     #
  #     # La tercer línea, la que corresponde a los mediocampistas, son el tercer
  #     # elemento de cada array (:average, :none, :captain, :none, :average)
  #     #
  #     # La cuarta línea está ubicada entre los mediocampistas y delanteros
  #     # (:none, :average, :none, :average, :none)
  #     #
  #     # Los últimos elementos de los arrays corresponden a la línea de
  #     # delanteros (:none, :none, :fast, :average, :none)
  #     formation.lineup = [
  #       [:average, :none, :average, :none,    :none],
  #       [:fast,    :none, :none,    :average, :none],
  #       [:none,    :none, :captain, :none,    :fast],
  #       [:fast,    :none, :none,    :average, :average],
  #       [:average, :none, :average, :none,    :none],
  #     ]

  #     formation
  #   end
  # end

  # Otra implementación posible de una instancia de Coach

  # Gran parte de la gracia de este juego está en hacer cambios en la formación
  # a medida que va transcurriendo el partido
  #
  # La instancia de `match` que recibe el método `formation` contiene información
  # sobre el partido y el rival de turno
  #
  # Veamos un ejemplo

  # class MyCoach < Coach
  #   def name
  #     "Villa Pancha"
  #   end

  #   def formation(match)
  #     formation = Formation.new



  #     formation
  #   end
  # end
end