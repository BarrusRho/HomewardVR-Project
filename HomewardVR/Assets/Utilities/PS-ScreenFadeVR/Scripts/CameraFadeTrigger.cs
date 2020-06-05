using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace PlayfulSystems.ScreenFade {
    public class CameraFadeTrigger : MonoBehaviour {

        public enum Behavior : byte {
            None, FadeIn, FadeOut, FadeOutToScene
        }

        [Tooltip("If this component is enabled, what should it do automatically?")]
        public Behavior onEnable = Behavior.None;

        public Color fadeColor = Color.black;
        public float durationFadeIn = 0.5f;
        public float durationFadeOut = 0.25f;

        [Tooltip("If this is 0 or higher, the Fader will try to switch to this scene if it fades out to scene")]
        public int sceneNumber = -1;

        public void OnEnable() {
            switch (onEnable) {
                case Behavior.FadeIn:
                    FadeIn();
                    break;
                case Behavior.FadeOut:
                    FadeOut();
                    break;
                case Behavior.FadeOutToScene:
                    FadeOutToScene(sceneNumber);
                    break;
                default:
                    break;
            }
        }

        public void FadeIn() {
            CameraFadeEffect.TriggerFade(fadeColor, 1f, 0f, durationFadeIn);
        }

        public void FadeOut() {
            CameraFadeEffect.TriggerFade(fadeColor, 0f, 1f, durationFadeOut);
        }

        public void FadeOutToScene() {
            FadeOutToScene(sceneNumber);
        }

        public void FadeOutToScene(int scene) {
            if (scene >= 0)
                FadeToScene.LoadScene(scene, fadeColor, durationFadeOut);
            else
                CameraFadeEffect.TriggerFade(fadeColor, 0f, 1f, durationFadeOut);
        }

    }
}