import time
import pyautogui

preWait = 5
print(f"Getting started in {preWait} sec")
time.sleep(preWait)


def simulate():
 
    # value = r"vPark#9WO64ypR9oq"
    # value = r"up32ks4180"
    # value = r"ks4180"
    # value = r"9616205455"
    value = r"04:85:4F:AA:75:14:90"

    pyautogui.typewrite("uoer")
    time.sleep(0.5)

    pyautogui.typewrite(value)
    pyautogui.press("enter")
    print(f"simulated {value}")


# i = 0

# while i < 3:
#     simulate()
#     time.sleep(0.5)
#     i+=1

# time.sleep(1)

simulate()