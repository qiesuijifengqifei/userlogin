import pytest
import subprocess
import os


if __name__ == "__main__":
    # 使用pytest.main()启动测试会话
    rootdir = os.path.dirname(__file__)             # rootdir 必须从命令行传入,从此路径查找 pytest.ini, 生成 .pytest_cache 文件夹
    allure_results = rootdir + "/../build/pytest/allure_results"
    allure_report = rootdir + "/../build/pytest/allure_report"
    testpaths = rootdir + "/cases"


    pytest_result = pytest.main([
        f"--rootdir={rootdir}",
        f"--alluredir={allure_results}",
        f"{testpaths}",             # 指定测试的目录
        ])

    # 如果测试通过，则生成allure报告
    # if pytest_result == 0:

    # 生成 allure 报告
    allure_generate_command = f"allure generate {allure_results} -o {allure_report} --clean --single-file"
    subprocess.run(allure_generate_command, shell=True)
