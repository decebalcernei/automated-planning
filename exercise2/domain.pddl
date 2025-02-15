(define (domain emergency-services-logistics)
  (:requirements :strips :typing :negative-preconditions)
  (:types
    robotic_agent
    location
    box
    content
    person
    carrier
    capacity
  )
  
    (:constants
        food - content
        tools - content
        medicine - content
        depot - location
        zero one two three four - capacity
    )

  (:predicates     
    (empty ?b - box)              
    (content_in_box ?c - content ?b - box)    ;il contenuto è nella box 
    (content_needed ?p - person ?c - content) ;il bisogno di ogni singola persona 


    (at_robot_loc ?r - robotic_agent ?l - location)     
    (at_box_loc ?b - box ?l - location)      
    (at_content_loc ?c - content ?l - location)
    (at_person_loc ?c - person ?l - location)


    (attached_carrier ?r - robotic_agent ?ca - carrier)
    (empty_robot ?r - robotic_agent) ; il robot non ha carrier
    (holding ?r - robotic_agent ?b - box)
 
    ;carrier 
    (loaded ?ca - carrier ?b - box)
    (at_carrier_loc ?ca - carrier ?l - location)

    ;capacity
    (succ ?c0 - capacity ?c1 - capacity)
    (pred ?c0 - capacity ?c1 - capacity)
    (num_box_on_carrier ?ca - carrier ?cap - capacity)
  )

    ;; attach carrier to robot, in our case. Like problem statement states
    ;; this instead of robotic agent could be airplane or other transportation vehicle
  (:action attach_carrier
    :parameters (?r - robotic_agent ?ca - carrier ?l - location )
    :precondition (and
      (at_robot_loc ?r ?l)
      (at_carrier_loc ?ca ?l)
      (empty_robot ?r)
      (not (attached_carrier ?r ?ca))
    )
    :effect (and
        (not (empty_robot ?r))
        (attached_carrier ?r ?ca)
    )
  )

  
  (:action load_carrier
    :parameters (?r - robotic_agent ?l - location ?ca - carrier ?b - box ?c0 ?c1 - capacity)
    :precondition (and
      (at_robot_loc ?r ?l)
      (at_carrier_loc ?ca ?l)
      (at_box_loc ?b ?l)
      (attached_carrier ?r ?ca)
      (not (empty ?b))
            ;; added capacity
      (num_box_on_carrier ?ca ?c0)
      (succ ?c0 ?c1)
      (not (num_box_on_carrier ?ca four))
    )
    :effect (and
        (loaded ?ca ?b)
        (not (num_box_on_carrier ?ca ?c0))
        (num_box_on_carrier ?ca ?c1)
        
    )
  )


  (:action pickup
    :parameters(?r - robotic_agent ?l - location ?b - box)
    :precondition (and
        (at_box_loc ?b ?l)
        (at_robot_loc ?r ?l)
        (empty ?b)
        (not (holding ?r ?b))
    )
    :effect(and
    	(holding ?r ?b)
        )
    )


  (:action fill
    :parameters(?r - robotic_agent ?l - location ?b - box ?p - person ?c - content)
    :precondition (and 
        (at_content_loc ?c ?l)
        (at_box_loc ?b ?l)
        (at_robot_loc ?r ?l)
        (empty ?b)
        (holding ?r ?b)
        (content_needed ?p ?c)
    )
    :effect(and
    	(not (empty ?b))
        (content_in_box ?c ?b)
        )
  )
 
  (:action move
    :parameters (?r - robotic_agent ?from ?to - location ?ca - carrier)
    :precondition (and
      (not (num_box_on_carrier ?ca zero))
      (at_robot_loc ?r ?from)
      (not (at_robot_loc ?r ?to))
    )
    :effect (and
      (at_robot_loc ?r ?to)
      (not (at_robot_loc ?r ?from))
    )
  )

  (:action move_to_depot
    :parameters (?r - robotic_agent ?from - location ?ca - carrier)
    :precondition (and
      (num_box_on_carrier ?ca zero)
      (at_robot_loc ?r ?from)
    )
    :effect (and
      (at_robot_loc ?r depot)
      (not (at_robot_loc ?r ?from))
    )
  )
  

  (:action deliver
    :parameters (?r - robotic_agent ?l - location ?b - box ?ca - carrier ?c - content ?p - person ?c0 ?c1 - capacity)
    :precondition (and
      (at_robot_loc ?r ?l)
      (at_person_loc ?p ?l)
      (attached_carrier ?r ?ca)
      (loaded ?ca ?b)
      (not (empty ?b))
      (content_needed ?p ?c)
      (content_in_box ?c ?b)
        ;; added capacity
      (pred ?c0 ?c1)
      (num_box_on_carrier ?ca ?c0)
    )
    :effect(and
        (empty ?b) 
        (not (at_box_loc ?b ?l))
        (not (loaded ?ca ?b))
        (not (content_needed ?p ?c))
        (not (num_box_on_carrier ?ca ?c0))
        (num_box_on_carrier ?ca ?c1)
    )
  )
)