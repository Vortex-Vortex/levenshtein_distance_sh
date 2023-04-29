#!/bin/bash

levenshtein() {
    target=$1
    given=$2
    t_len=${#target}
    g_len=${#given}
    declare -A matrix

    for (( g_ind=0; $g_ind<=$g_len; g_ind++ )); do
        for (( t_ind=0; $t_ind<=$t_len; t_ind++ )); do
            (( $g_ind == 0 )) && matrix[0,$t_ind]=$t_ind
            (( $t_ind == 0 )) && matrix[$g_ind,0]=$g_ind
        done
    done

    for (( g_ind=0; g_ind<g_len; g_ind++ )); do
        (( next_g_ind = $g_ind + 1 ))
        for (( t_ind=0; t_ind<$t_len; t_ind++ )); do
            [[ "${target:t_ind:1}" == "${given:g_ind:1}" ]] && cost=0 || cost=1
            (( next_t_ind = $t_ind + 1 ))

            del=${matrix[$g_ind,$next_t_ind]}
            ins=${matrix[$next_g_ind,$t_ind]}
            rep=${matrix[$g_ind,$t_ind]}

            (( matrix[$next_g_ind,$next_t_ind] = $cost == 0 ? $rep : ($ins <= $del ? ($ins <= $rep ? $ins : $rep) : ($del <= $rep ? $del : $rep)) + 1 ))
        done
    done
    echo ${matrix[$next_g_ind,$next_t_ind]}
}
levenshtein "$1" "$2"
