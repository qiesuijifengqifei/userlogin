#!/bin/bash

function __project()
{
    local cur pre opts
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    # 获取键入最后一个选项
    pre=${COMP_WORDS[COMP_CWORD - 1]}
    # 获取键入最后第二个选项
    

    case "${COMP_CWORD}" in
    # COMP_CWORD 类型为整数，当前输入的单词在 COMP_WORDS 中的索引
        1)
            local opts="run stop build test install"
             # 补全项字符串定义            
        ;;
        2)
            case ${pre} in
            "run" | "build")
                local opts="backend frontend all"
                ;;
            "stop")
                local opts="backend nodejs all"
                ;;
            "install")
                local opts="module runtime"
                ;;
            esac
        ;;
        3)
            case ${pre} in
            "module")
                local opts="backend frontend pytest all"
                ;;
            "runtime")
                local opts="$(ls ${SCRIPTS_PATH}/install | cut -d'_' -f 2 | tr '\n' ' ' | sed 's/\.sh//g' | xargs echo -n all )"
                ;;
            esac
        ;;        
    esac

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    
}

# complete -F __project -A file project     # -A file 表示显示当前路径下文件
complete -F __project project

