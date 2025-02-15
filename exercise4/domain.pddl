(define (domain emergency-services-logistics)
  (:requirements :strips :typing :durative-actions :fluents)
  (:types
    robotic_agent
    location
    box
    content
    person
    carrier
  )
  
  (:constants
      f1 - content
      t1 - content
      m1 - content
      d1 - location
  )
  

  (:functions
        (capacity_carrier ?ca - carrier) ; Definizione della funzione capacity che restituisce un valore numerico per il carrier ?c
        (box_on_carrier ?ca - carrier)
        (content_on_carrier ?ca - carrier)
        (num_box ?b - box)
    
  )


  (:predicates
    ;(same ?l1 ?l2 - location)      
    (empty ?b - box)              
    (full ?b - box)
    (content_in_box ?c - content ?b - box)    ;il contenuto è nella box 
    (content_needed ?p - person ?c - content) ;il bisogno di ogni singola persona 
    (non_content_needed ?p - person ?c - content)

    (at_robot_loc ?r - robotic_agent ?l - location)     
    (at_box_loc ?b - box ?l - location)      
    (at_content_loc ?c - content ?l - location)
    (at_person_loc ?c - person ?l - location)

    ;(have ?p - person ?b - box)
    (loaded_carrier ?r - robotic_agent ?ca - carrier)
    ;(delivered ?b - box)
    ;(empty_robot ?r - robotic_agent)
    ;(inqueue ?ca - carrier ?b - box)
 
    ;carrier 
    ;(load_carrier_on_robot ?ca - carrier ?r - robotic_agent)
    (loaded ?ca - carrier ?b - box)
    (at_carrier_loc ?ca - carrier ?l - location)
  )
  
  
  (:durative-action load_carrier_durative
      :parameters (?r - robotic_agent ?l - location ?ca - carrier ?b - box)
      :duration (= ?duration 2)
      :condition (and (at start (at_robot_loc ?r ?l))
                      (at start (at_carrier_loc ?ca ?l))
                      (at start (at_box_loc ?b ?l))
                      (over all (loaded_carrier ?r ?ca))
                      (over all (full ?b))
                      (at start(< (box_on_carrier ?ca) (capacity_carrier ?ca)))
      )
      :effect (and 
                    (at start (full ?b))
                    (at end (not (empty ?b)))
                    (at start (not (at_box_loc ?b ?l)))
                    (at end (loaded ?ca ?b))
                    (at end (increase (box_on_carrier ?ca) 1))
                   
      )
  )

  (:durative-action move_to_depot
      :parameters (?r - robotic_agent ?from ?to - location ?ca - carrier)
      :duration (= ?duration 10)
      :condition (and (at start (at_robot_loc ?r ?from))
                      (at start (= (box_on_carrier ?ca) 0))    
      )
      :effect (and 
                    ;(at start (not (at_robot_loc ?r ?to)))
                    (at end (at_robot_loc ?r d1))
                   (at start (not (at_robot_loc ?r ?from)))
      )
  
  )
  
  
  (:durative-action pickup_boxes_And_Fill
      :parameters (?r - robotic_agent ?l - location ?ca - carrier ?b - box ?p - person ?c - content)
      :duration (= ?duration 4)
      :condition (and (at start (at_content_loc ?c ?l))
                      (at start (at_box_loc ?b ?l))
                      (at start (at_robot_loc ?r ?l))
                      (over all (content_needed ?p ?c))
                      (at start (empty ?b))
                      
      )
      :effect (and (at end (full ?b))
                   (at end (content_in_box ?c ?b))
      )
  )
  
  
  (:durative-action move
      :parameters (?r - robotic_agent ?from ?to - location ?ca - carrier)
      :duration (= ?duration 10)
      :condition (and (at start (at_robot_loc ?r ?from))
                      ;(at start (> (box_on_carrier ?ca) 1))
                      ;(at start (not (at_robot_loc ?r ?to)))    
      )
      :effect (and 
                    ;(at start (not (at_robot_loc ?r ?to)))
                    (at end (at_robot_loc ?r ?to))
                   (at start (not (at_robot_loc ?r ?from)))
      )
  )
  
  (:durative-action deliver
      :parameters (?r - robotic_agent ?l - location ?b - box ?ca - carrier ?c - content ?p - person)
      :duration (= ?duration 3)
      :condition (and (at start (at_robot_loc ?r ?l))
                      (at start (at_person_loc ?p ?l))
                      (at start (loaded ?ca ?b))
                      (at start (full ?b))
                      (at start (content_needed ?p ?c))
                      (at start (content_in_box ?c ?b))
      )
      :effect (and (at end (empty ?b))
                   (at end (not (at_box_loc ?b ?l)))
                   (at end (not (loaded ?ca ?b)))
                   (at end (not (content_needed ?p ?c)))
                   (at end (non_content_needed ?p ?c))
                   (at end (decrease (box_on_carrier ?ca) 1))
      )
  )
)
