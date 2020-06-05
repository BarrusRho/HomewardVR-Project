using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace PlayfulSystems.ScreenFade {
    public class FadeToScene {

        static int sceneToLoad;

        public static void LoadScene(string name, float duration = 1f) {
            LoadScene(name, Color.black, duration);
        }

        public static void LoadScene(string name, Color fadeColor, float duration = 1f) {
            var scene = SceneManager.GetSceneByName(name);
            
            if (!scene.IsValid()) {
                Debug.LogWarning("[FadeToScene] Scene " + name + " is not valid!");
                return;
            }

            DoFadeAndWait(scene.buildIndex, fadeColor, duration);
        }

        public static void LoadScene(int number, float duration = 1f) {
            LoadScene(number, Color.black, duration);
        }

        public static void LoadScene(int number, Color fadeColor, float duration = 1f) {
            if (number < 0 || number >= SceneManager.sceneCountInBuildSettings) {
                Debug.LogWarning("[FadeToScene] Scene number " + number + " does not exist!");
                return;
            }

            DoFadeAndWait(number, fadeColor, duration);
        }

        static void DoFadeAndWait(int number, Color fadeColor, float duration) {
            sceneToLoad = number;
            CameraFadeEffect.TriggerFade(fadeColor, 0f, 1f, duration, LoadAfterFade);
        }

        static void LoadAfterFade() {
            SceneManager.LoadScene(sceneToLoad);
        }

        static int GetBuildIndexOfScene(string name) {
            var scene = SceneManager.GetSceneByName(name);

            if (scene.IsValid())
                return scene.buildIndex;
            else
                return -1;
        }
    }
}