using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class UIManager : MonoBehaviour
{
    [SerializeField]
    private OVRInput.Controller m_controller;

    public OVRInput.Button pauseButton;

    public bool isGamePaused = false;  

    [SerializeField]
    private GameObject gamePauseCanvas;

    // Start is called before the first frame update
    void Start()
    {
        gamePauseCanvas.SetActive(false);       

        isGamePaused = false;

        Time.timeScale = 1.0f;

        AudioListener.pause = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (OVRInput.GetDown(pauseButton) && isGamePaused == false)
        {
            PauseGame();
        }
    }

    public void PauseGame()
    {
        Time.timeScale = 0.0f;        

        isGamePaused = true;

        AudioListener.pause = true;

        gamePauseCanvas.SetActive(true);
    }

    public void UnPauseGame()
    {
        Time.timeScale = 1.0f;        

        isGamePaused = false;

        AudioListener.pause = false;

        gamePauseCanvas.SetActive(false);
    }

    public void ResumeGame()
    {
        Time.timeScale = 1.0f;        

        AudioListener.pause = false;

        isGamePaused = false;

        gamePauseCanvas.SetActive(false);
    }

    public void ReturnToMainMenu()
    {
        SceneManager.LoadScene("Main_Menu");
    }

    public void RestartGame()
    {
        SceneManager.LoadScene("Level_One");
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}