#! /bin/bash

# map 1
log maps "setting map 1"

function map.1.1 {
    log maps "drawing map 1.1"
    echo -e "
    #   = you
    *   = travelpoint
    &   = telepad
    1-9 = an option to travel to

            #       *
             \      |
              \     |
               \    *--------&
        *-------2_  |
                  \ /
                   *
                   |
                   /
              *___/
            _/
    &--____/

_______________________________________"
keypad 1 1

}
function map.1.2 {
    log maps "drawing map 1.2"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9 = an option to travel to

            1       *
             \      |
              \     |
               \    *--------&
        3-------#_  |
                  \ /
                   4
                   |
                   /
              *___/
            _/
    &--____/

_______________________________________"
keypad 1 2

}
function map.1.3 {
    log maps "drawing map 1.3"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9 = an option to travel to

            *       *
             \      |
              \     |
               \    *--------&
        #-------2_  |
                  \ /
                   *
                   |
                   /
              *___/
            _/
    &--____/

_______________________________________"
keypad 1 3

}
function map.1.4 {
    log maps "drawing map 1.4"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9 = an option to travel to

            *       *
             \      |
              \     |
               \    6--------&
        *-------2_  |
                  \ /
                   #
                   |
                   /
              8___/
            _/
    &--____/

_______________________________________"
keypad 1 4

}
function map.1.5 {
    log maps "drawing map 1.5"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

            *       #
             \      |
              \     |
               \    6--------&
        *-------*_  |
                  \ /
                   *
                   |
                   /
              *___/
            _/
    &--____/

_______________________________________
there is stone here! use a pickaxe to mine."
keypad 1 5

}
function map.1.6 {
    log maps "drawing map 1.6"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

            *       5
             \      |
              \     |
               \    #--------7
        *-------*_  |
                  \ /
                   4
                   |
                   /
              *___/
            _/
    &--____/

_______________________________________"
keypad 1 6

}
function map.1.7 {
    log maps "drawing map 1.7"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

            *       *
             \      |
              \     |
               \    6--------#
        *-------*_  |
                  \ /
                   *
                   |
                   /
              *___/
            _/
    t--____/

_______________________________________
teleport station ! network is tp-1.
use t to open the menu of tp-network 1."
keypad 1 7

}
function map.1.8 {
    log maps "drawing map 1.8"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

            *       *
             \      |
              \     |
               \    *--------*
        *-------*_  |
                  \ /
                   4
                   |
                   /
              #___/
            _/
    9--____/

_______________________________________
use [e] to open the merchant's menu"
keypad 1 8

}
function map.1.9 {
    log maps "drawing map 1.9"
    echo -e "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

            *       *
             \      |
              \     |
               \    *--------t
        *-------*_  |
                  \ /
                   *
                   |
                   /
              8___/
            _/
    #--____/

_______________________________________
teleport station ! network is tp-1.
use t to open the menu of tp-network 1."
keypad 1 9

}

log maps "done setting map 1"

# map 2
log maps "loading map 2"

  #     5
  #      \__
  #     ____]_____6
  #    /
  #    4       ____2__
  #   /    __/    ]   \__1
  #  [____/    __/
  #           |_____3


function map.2.1 {
  log maps "drawing map 2.1"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      *
       \__
      ____]_____*
     /
     *      _____2__
    /    __/    ]   \__#
   [____/    __/
            |_____*

_______________________________________"
keypad 2 1

}

function map.2.2 {
  log maps "drawing map 2.2"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      *
       \__
      ____]_____*
     /
     4      _____#__
    /    __/    ]   \__1
   [____/    __/
            |_____3

_______________________________________"
keypad 2 2

}

function map.2.3 {
  log maps "drawing map 2.3"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      *
       \__
      ____]_____*
     /
     *      _____2__
    /    __/    ]   \__&
   [____/    __/
            |_____*

_______________________________________"
keypad 2 3

}

function map.2.4 {
  log maps "drawing map 2.4"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      5
       \__
      ____]_____6
     /
     #       ____2__
    /    __/    ]   \__&
   [____/    __/
            |_____*

_______________________________________"
keypad 2 4

}

function map.2.5 {
  log maps "drawing map 2.5"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      #
       \__
      ____]_____6
     /
     4       ____*__
    /    __/    ]   \__&
   [____/    __/
            |_____*

_______________________________________"
keypad 2 5 
}

function map.2.6 {
  log maps "drawing map 2.6"
  echo "
    #    = you
    *    = travelpoint
    &    = telepad
    1-9  = an option to travel to

      5
       \__
      ____]_____#
     /
     4       ____*__
    /    __/    ]   \__&
   [____/    __/
            |_____*

_______________________________________"
keypad 2 6 
}

log maps "done loading map 2"