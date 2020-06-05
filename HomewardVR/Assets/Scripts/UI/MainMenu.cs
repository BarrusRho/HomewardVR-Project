using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using PlayfulSystems.ScreenFade;

public class MainMenu : MonoBehaviour
{  
    public bool isGamePaused = false;

    // Start is called before the first frame update
    void Start()
    {
        ResumeGame();      
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayGame()
    {
        Debug.Log("Level One is loading...");

        //FadeToScene.LoadScene("Level_One", Color.black, 5f);

        //CameraFadeEffect.TriggerFade(Color.black, 255f, 0f, 5f);

        SceneManager.LoadScene("Level_One");
    }    

    public void ResumeGame()
    {
        Time.timeScale = 1.0f;

        isGamePaused = false;
    }

    public void QuitGame()
    {
        Debug.Log("Quitting the game...");

        Application.Quit();
    }
}
