using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class CreditsMenu : MonoBehaviour
{   
    public bool isGamePaused = false; 

    // Start is called before the first frame update
    void Start()
    {
        isGamePaused = false;

        Time.timeScale = 1.0f;

        AudioListener.pause = false;
    }    

    public void ReturnToMainMenu()
    {
        SceneManager.LoadScene("Main_Menu");
    }   

    public void QuitGame()
    {
        Application.Quit();
    }
}