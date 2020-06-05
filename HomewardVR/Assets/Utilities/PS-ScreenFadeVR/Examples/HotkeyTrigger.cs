using UnityEngine;
using UnityEngine.Events;

namespace PlayfulSystems.ScreenFade { 
    public class HotkeyTrigger : MonoBehaviour {

        public KeyCode hotkey;
        public UnityEvent onHotkey;

        public void Update() {
            if (Input.GetKeyDown(hotkey))
                onHotkey.Invoke();
        }

    }
}