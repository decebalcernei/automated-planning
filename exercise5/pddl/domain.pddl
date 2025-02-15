(define (domain emergency-services-logistics)
  (:requirements :strips :typing :adl :fluents :durative-actions)
  (:types
    robotic_agent
    location
    box
    content
    person
    carrier
    capacity
  )


(:predicates     
    (empty ?b - box)
    (full ?b - box)     
    (content_in_box ?c - content ?b - box)    ;il contenuto è nella box 
    (content_needed ?p - person ?c - content) ;il bisogno di ogni singola persona
    (not_content_needed ?p - person ?c - content)

    (not_delivered ?p - person ?c - content)
    (delivered ?p - person ?c - content)


    (at_robot_loc ?r - robotic_agent ?l - location)     
    (at_box_loc ?b - box ?l - location)      
    (at_content_loc ?c - content ?l - location)
    (at_person_loc ?c - person ?l - location)


    (attached_carrier ?r - robotic_agent ?ca - carrier)
    (not_attached_carrier ?r - robotic_agent ?ca - carrier)

    (empty_robot ?r - robotic_agent) ; il robot non ha carrier
    (holding ?r - robotic_agent ?b - box)
    (not_holding ?r - robotic_agent ?b - box)
 
    ;carrier 
    (loaded ?ca - carrier ?b - box)
    (not_loaded ?ca - carrier ?b - box)
    (at_carrier_loc ?ca - carrier ?l - location)

    ;capacity
    (succ ?c0 - capacity ?c1 - capacity)
    (pred ?c0 - capacity ?c1 - capacity)
    (num_box_on_carrier ?ca - carrier ?cap - capacity)
)

    ;; attach carrier to robot, in our case. Like problem statement states
    ;; this instead of robotic agent could be airplane or other transportation vehicle

(:durative-action attach_carrier
    :parameters (?r - robotic_agent ?ca - carrier ?l - location)
    :duration ( = ?duration 2)
    :condition (and
      (at start (at_robot_loc ?r ?l))
      (at start (at_carrier_loc ?ca ?l))
      (at start (empty_robot ?r))
      (at start (not_attached_carrier ?r ?ca))
    )
    :effect (and
        (at start (not (empty_robot ?r)))
        (at start (not (not_attached_carrier ?r ?ca)))
        (at end (attached_carrier ?r ?ca))
    )
)

  
(:durative-action load_carrier
    :parameters (?r - robotic_agent ?l - location ?ca - carrier ?b - box ?c0 ?c1 - capacity)
    :duration ( = ?duration 4)
    :condition (and
      (at start (at_robot_loc ?r ?l))
      (at start (at_carrier_loc ?ca ?l))
      (at start (at_box_loc ?b ?l))
      (at start (not_loaded ?ca ?b))
      (over all (attached_carrier ?r ?ca))
      (over all (full ?b))
            ;; added capacity
      (at start (num_box_on_carrier ?ca ?c0))
      (over all (succ ?c0 ?c1))
      ;;;;;;;;;;(not (num_box_on_carrier ?ca four))
    )
    :effect (and
        (at start (not (num_box_on_carrier ?ca ?c0)))
        (at start (num_box_on_carrier ?ca ?c1))
        (at start (not (not_loaded ?ca ?b)))
        (at end (loaded ?ca ?b))
    )
)


(:durative-action pickup
    :parameters(?r - robotic_agent ?l - location ?b - box ?ca - carrier)
    :duration ( = ?duration 1)
    :condition (and
        (at start (at_box_loc ?b ?l))
        (at start (at_robot_loc ?r ?l))
        (over all (empty ?b))
        (at start (not_holding ?r ?b))
        (over all (attached_carrier ?r ?ca))
    )
    :effect(and
        (at start (not_holding ?r ?b))
    	(at end (holding ?r ?b))
        )
)


(:durative-action fill
    :parameters(?r - robotic_agent ?l - location ?b - box ?p - person ?c - content ?ca - carrier)
    :duration ( = ?duration 2)
    :condition (and 
        (at start (at_content_loc ?c ?l))
        (at start (at_box_loc ?b ?l))
        (at start (at_robot_loc ?r ?l))
        (at start (empty ?b))
        (at start (holding ?r ?b))
        (over all (content_needed ?p ?c))
        (over all (attached_carrier ?r ?ca))
    )
    :effect(and
    	(at start (not (empty ?b)))
        (at start (not (holding ?r ?b)))
        (at end (not_holding ?r ?b))
        (at end (full ?b))
        (at end (content_in_box ?c ?b))
        )
)
 
(:durative-action move
    :parameters (?r - robotic_agent ?from ?to - location ?ca - carrier)
    :duration (= ?duration 10)
    :condition (and
        (at start (at_robot_loc ?r ?from))
        (over all (attached_carrier ?r ?ca))
        ;(at start (attached_carrier ?r ?ca))
      )
      :effect (and
          (at start (not (at_robot_loc ?r ?from)))
          (at end (at_robot_loc ?r ?to))
      )
)

(:durative-action deliver
    :parameters (?r - robotic_agent ?l - location ?b - box ?ca - carrier ?c - content ?p - person ?c0 ?c1 - capacity)
    :duration ( = ?duration 5)
    :condition (and
      (at start (at_robot_loc ?r ?l))
      (at start (at_person_loc ?p ?l))
      (over all (attached_carrier ?r ?ca))
      (at start (loaded ?ca ?b))
      (at start (full ?b))
      (at start (content_needed ?p ?c))
      (at start (content_in_box ?c ?b))
        ;; added capacity
      (over all (pred ?c0 ?c1))
      (at start (num_box_on_carrier ?ca ?c0))
      (at start (not_delivered ?p ?c))
    )
    :effect(and
        (at start (not (not_delivered ?p ?c)))
        (at start (not (full ?b)))
        (at start (not (content_needed ?p ?c)))
        (at end (empty ?b))
        (at end (not (loaded ?ca ?b)))
        ;(at end (not_content_needed ?p ?c))
        (at end (not (num_box_on_carrier ?ca ?c0)))
        (at end (num_box_on_carrier ?ca ?c1))
        (at end (delivered ?p ?c))
    )
  )
)