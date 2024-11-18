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
             # 补全项字符串定义            
            local opts="run stop build test release install set_pip3"
        ;;
        2)
            case ${pre} in
            "run" | "build")
                local opts="backend frontend pages all"
                ;;
            "stop")
                local opts="backend nodejs all"
                ;;
            "release")
                local opts="del_deployment package upload"
                ;;
            "install")
                local opts="module runtime"
                ;;
            "set_pip3")
                local opts="default tsinghua"
                ;;
            esac
        ;;
        3)
            case ${pre} in
            "module")
                local opts="backend frontend pytest pages all"
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

