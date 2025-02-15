(define (domain emergency-services-logistics)
  (:requirements :strips :typing :negative-preconditions)
  (:types
    robotic_agent
    location
    box
    content - object
    person
  )

  (:constants
    food - content
    tools - content
    medicine - content
    depot - location
  )


  (:predicates
    (empty ?b - box)
    (content_in_box ?c - content ?b - box)    ;il contenuto è nella box 
    (content_needed ?p - person ?c - content) ;il bisogno di ogni singola persona 

    (at_robot_loc ?r - robotic_agent ?l - location)     
    (at_box_loc ?b - box ?l - location)      
    (at_content_loc ?c - content ?l - location)
    (at_person_loc ?c - person ?l - location)

    (loaded ?r - robotic_agent ?b - box)
    (empty_robot ?r - robotic_agent)
  )


  (:action pickup
    :parameters (?r - robotic_agent ?l - location ?b - box)
    :precondition (and
      (at_robot_loc ?r ?l)
      (at_box_loc ?b ?l)
      (empty ?b)
      (not (loaded ?r ?b))
      (empty_robot ?r)
    )
    :effect (and 
        (loaded ?r ?b)
        (not (empty_robot ?r))
        )
  )


  (:action fill
    :parameters (?r - robotic_agent ?l - location ?b - box ?c - content ?p - person)
    :precondition (and 
      (at_robot_loc ?r ?l)
      (at_content_loc ?c ?l)
      (empty ?b)
      (not (empty_robot ?r))
      (loaded ?r ?b)
      (content_needed ?p ?c)
    )
    :effect (and (not (empty ?b))
        (content_in_box ?c ?b))
  )

    ; Nella prima versione avevamo due azioni move, una verso la persona e l'altra verso il depot
    ; Le abbiamo unite in una singola

  (:action move
    :parameters (?r - robotic_agent ?from ?to - location)
    :precondition (and
      (at_robot_loc ?r ?from)
      (not (at_robot_loc ?r ?to))
    )
    :effect (and
      (at_robot_loc ?r ?to)
      (not (at_robot_loc ?r ?from))
    )
  )

  
  (:action deliver
    :parameters (?r - robotic_agent ?l - location ?b - box ?c - content ?p - person)
    :precondition (and
      (at_robot_loc ?r ?l)
      (at_person_loc ?p ?l)
      (not (empty_robot ?r))
      (loaded ?r ?b)
      (not (empty ?b))
      (content_needed ?p ?c) 
      (content_in_box ?c ?b)
    )
    :effect(and
        (not (content_in_box ?c ?b))
        (empty ?b)
        (not (content_needed ?p ?c))
    )
  )
)